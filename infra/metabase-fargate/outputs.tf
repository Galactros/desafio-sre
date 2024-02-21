output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = module.zones.route53_zone_name_servers
}

output "route53_record_name" {
  description = "The name of the record"
  value       = module.records.route53_record_name
}