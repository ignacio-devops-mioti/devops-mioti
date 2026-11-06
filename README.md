# devops-mioti

Repositorio del módulo **DevOps** de MIOTI Tech & Business School: Linux, Terraform en Azure, GitHub Actions y observabilidad.

Todo se usa en **GitHub Codespaces** (Ubuntu 24.04 en la nube): no hace falta instalar nada en tu ordenador.

| Sesión | Carpeta o fichero | Qué hay |
|---|---|---|
| S2 | `.devcontainer/` | El Codespace: un Ubuntu 24.04 limpio, como un WSL recién instalado |
| S4 | `terraform/azure-storage/` | Primer despliegue con Terraform: un Storage Account y un contenedor en Azure, con variables y etiquetas |
| S5 | `terraform/azure-storage/backend.tf` | Estado remoto en un contenedor de Azure |
| S5 | `.github/workflows/terraform.yml` | Pipeline de GitHub Actions: `fmt`, `init`, `validate` y `plan` en cada push o pull request; `apply` y `destroy` con el botón |
| Reto | `terraform/reto-vm/` y `.github/workflows/terraform-reto.yml` | Solución de referencia del reto final: una VM sin IP pública y una alerta de CPU |

## Cómo empezar

1. `git clone https://github.com/ignacio-devops-mioti/devops-mioti.git` (o *Code → Codespaces → Create codespace*).
2. Entra en Azure con `az login --use-device-code`.
3. En `terraform/azure-storage/`: `terraform init`, `terraform plan`, `terraform apply` y, al terminar, `terraform destroy`.

> Importante: después de cada práctica, `terraform destroy`. Lo que no se destruye, se paga.
>
> El nombre de un Storage Account es único en todo Azure: cambia el del ejemplo. Nunca subas `*.tfstate`, `.terraform/` ni secretos.
