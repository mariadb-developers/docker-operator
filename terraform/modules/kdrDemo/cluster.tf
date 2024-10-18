resource "digitalocean_kubernetes_cluster" "this" {
  name          = "${var.environment}-operator-demo"
  region        = "sfo2"
  auto_upgrade  = true
  surge_upgrade = true
  version       = "1.28.14-do.3"
  tags          = [var.environment]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }
}