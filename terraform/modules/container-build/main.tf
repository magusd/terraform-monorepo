resource "docker_registry_image" "ecr_image" {
  for_each      = { for t in var.images : t => t }
  name          = each.value
  keep_remotely = true
  triggers = {
    digest = docker_image.local_image.repo_digest
  }
  depends_on = [
    docker_image.local_image
  ]
}

resource "docker_image" "local_image" {
  name = var.images[0]
  build {
    context = "${path.cwd}/../../../"
    tag     = var.images
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(var.root_path, "*") : filesha1("${var.root_path}/${f}")]))
  }
}