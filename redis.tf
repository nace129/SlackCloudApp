resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "slack-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.default.name
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id]
}

output "aws_elasticache_cluster" {
  value = aws_elasticache_cluster.redis.cluster_id
}