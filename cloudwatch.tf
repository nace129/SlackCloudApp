resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/slack-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
}

output "aws_cloudwatch_metric_alarm" {
  value = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}