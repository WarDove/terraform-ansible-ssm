resource "null_resource" "ansible_os_patch" {

  provisioner "local-exec" {
    command = "ansible-playbook ${path.root}/playbooks/os_patch.yaml -vv"

    environment = {
      SSM_BUCKET_NAME = aws_s3_bucket.main.id
      SSM_INSTANCE_ID = aws_instance.main.id
    }
  }

  triggers = {
    playbook_update = filesha256("${path.root}/playbooks/os_patch.yaml")
    ssm_instance_id = aws_instance.main.id
    revision        = var.revision
  }
}

resource "null_resource" "ansible_app_install" {

  provisioner "local-exec" {
    command = "ansible-playbook ${path.root}/playbooks/app_install.yaml -vv"

    environment = {
      SSM_BUCKET_NAME = aws_s3_bucket.main.id
      SSM_INSTANCE_ID = aws_instance.main.id
    }
  }

  triggers = {
    playbook_update = filesha256("${path.root}/playbooks/app_install.yaml")
    ssm_instance_id = aws_instance.main.id
    revision        = var.revision
  }
}