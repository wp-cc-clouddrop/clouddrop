<div align="center">
<img src="clouddrop_logo_400x200.png">
</div>

# cloud-wp-ws19

Project repository for WP Cloud Computing WS19. This project consists of multiple repositories:

- [Master](https://github.com/wp-cc-clouddrop/clouddrop): configs for K8s deployments and services.
- [Files](https://github.com/wp-cc-clouddrop/files): handle uploaded files.
- [Users](https://github.com/wp-cc-clouddrop/users): handles user authentications and informations.

## Backups

Cluster backup is done with Velero.

On Azure, the tutorial used is: https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#Create-Azure-storage-account-and-blob-container

## Service Mesh

Linkerd used for service mesh. Installation of linkerd onto the k8s cluster done as described here: https://linkerd.io/2/getting-started/
