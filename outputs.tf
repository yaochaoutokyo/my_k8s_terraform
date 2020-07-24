output "nlb_public_dns" {
  value = aws_lb.kubernetes-nlb.dns_name
}

output "controller_external_ips" {
  value = aws_instance.master-node.*.public_ip
}

output "controller_internal_ips" {
  value = aws_instance.master-node.*.private_ip
}

output "worker_external_ips" {
  value = aws_instance.worker-node.*.public_ip
}

output "worker_internal_ips" {
  value = aws_instance.worker-node.*.private_ip
}