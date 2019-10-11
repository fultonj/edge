# Example: 3 central controller nodes + 3 edge HCI nodes
## Prerequisites

- A working Red Hat OpenStack Platform 15 undercloud
- Access to the the Red Hat Ceph Storage 4 beta
- 3 nodes introspected by Ironic which can act as central Controllers
- 3 nodes introspected by Ironic which can act as HCI compute/ceph nodes at edge site 1
- For each additional edge site, 3 more HCI compute/ceph nodes

## Procedure (working links coming soon)

- Modify [containers.yaml](containers.yaml) to use your Registry Service Account credentials and run [containers.sh](containers.sh), to [obtain the container images](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/15/html/transitioning_to_containerized_services/obtaining-container-images).
- Use [deploy.sh](central/deploy.sh) to deploy central controllers with [central/overrides.yaml](central/overrides.yaml)
- Use [extract.sh](extract.sh) to extract controller information into edge-common
- Use [deploy.sh](edge0/deploy.sh) to deploy an HCI node in AZ edge0 with [edge0/overrides.yaml](edge0/overrides.yaml) and [edge0/ceph.yaml](edge0/ceph.yaml)
- Run [edgeN.sh](edgeN.sh) which makes a copy of the templates from edge0 called edge1 and then repeats the previous step but for edge1 to create a second AZ called edge1
- Use [test.sh](test.sh) to test that the central site can schedule workloads on the edge site

## Resulting OpenStack Storage Architecture

Each Edge site is deployed in its own availability zone (used by Nova and Cinder)

### Glance
- Glance with Swift is used at the Central Site
- At any edge site Glance cache uses local disk
- The first Nova instance booted in an edge site availability zone will use HTTP GET to retrieve the image at the central site
- Subsequent Nova instnaces booted will use the cached copy of the image (provided the instance is booted on the same node where the image is cached)

### Cinder
- At any edge site a Cinder availability zone exists running the cinder-volume service
- The cinder-volume service will support running in full active/active in a future OSP15 update

### Ceph
- Ceph is not running on the Central site
- Each edge site runs its own Ceph cluster collocated (HCI) with Nova compute nodes
- The Ceph backend is only used for Cinder Volumes

This architecture will get improvements in the next version of OpenStack.
