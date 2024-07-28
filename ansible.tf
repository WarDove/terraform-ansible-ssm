resource "time_sleep" "wait_30_seconds" {
  depends_on      = [aws_instance.main]
  create_duration = var.revision == 1 ? "30s" : "0s"
}

resource "null_resource" "ansible_os_patch" {
  depends_on = [time_sleep.wait_30_seconds]

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
  depends_on = [time_sleep.wait_30_seconds]

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