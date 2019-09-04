provider "helm" {}

data "helm_repository" "stable" {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "kong"{
    name = "kong" 
    repository = "${data.helm_repository.stable.metadata.0.name}"
    chart = "kong"
    version = "0.16.1"
    values = [
      file("${path.module}/${var.values_dir}/kong-values.yml"),
    ]
    namespace = var.namespace
    timeout = 300
}    

resource "helm_release" "konga"{
    name = "konga" 
    chart = "${path.module}/${var.charts_dir}/konga"
    values = [
      file("${path.module}/${var.values_dir}/konga-values.yml"),
      templatefile("${path.module}/${var.values_dir}/konga-values.yml",
      {
          konga_fqdn = var.konga_fqdn,
      })
    ]
    namespace = var.namespace 
}    

