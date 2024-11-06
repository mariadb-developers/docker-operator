# docker-operator
A Docker Container to run to deploy the MariaDB Operator

# Demo to deploy MariaDB Operator and PhotoPrism Application with Docker/Terraform

[![License](https://img.shields.io/badge/mit-blue.svg)](https://opensource.org/licenses/mit)
![GitHub stars](https://img.shields.io/github/stars/mariadb-kester/docker-operator?style=social)
![GitHub forks](https://img.shields.io/github/forks/mariadb-kester/docker-operator?style=social)

This project is designed to create a containerised Kubernetes infrastructure on DigitalOcean, and deploy the following
using automation:

- [MariaDB Kubernetes Operator]([https://mariadb.com])
- Photo App test application

For this demonstration to work, you will require various [third party accounts](#third-party-accounts).

---

### Terms of use

**Nothing in this demonstration is designed to be used in production and this is not supplied, supported or endorsed by MariaDB.**

*Please note the free $200 credit is enough to run this demonstration, however, if you do not decommission your services, or you use more than the free credit you will be liable for the cost.*
*Don't worry, Digital Ocean makes it easy to do with a cascade delete of related resources, and there is a terraform script for that purpose just in case.*
---

### Prerequisites

### You!

You require a certain level of technical knowledge to complete this, as you are required to install some tools to your
computer.

The demonstration is designed to run within a Docker Environment.

### Third Party Accounts

You will require FREE accounts for:

- [Github](./docs/files/github/readme.md)
- [Digital Ocean](./docs/files/digitalocean/readme.md)

[Digital Ocean](./docs/files/digitalocean/readme.md) supports Single Sign
On (SSO) using your GitHub account. SSO allows easy navigation between the services and allows you to link the accounts together.

It is important to create your [Github](./docs/files/github/readme.md) account before creating the other accounts.




---

## Getting Started

Hopefully you have already created the [Third Party Accounts](#third-party-accounts) required.
Before you begin, simply realize that you'll be building a local container to run terraform scripts, that in turn create the remote Kubernetes cluster on Digital Ocean.

(1) Create a local directory for development, and then fork this repo to it. https://github.com/mariadb-pieterhumphrey/docker-operator/

Then [fork](./docs/files/github/fork.md) the remaining repositories that support the main one.

(2) You may want to change a few settings in your your newly forked docker-operator repo, regarding how Terraform will create the target DO K8s cluster. You can find the reference values for region, droplet (virtual machine) and Kubernetes versions [here on Digital Ocean's documentation](https://slugs.do-api.dev/).

* RECOMMENDED: Change Region setting [region slugs](https://github.com/mariadb-pieterhumphrey/docker-operator/blob/main/terraform/modules/kdrDemo/cluster.tf#L3)
* RECOMMENDED: Check Digitial Ocean's K8s version slug [terraform file](https://github.com/mariadb-pieterhumphrey/docker-operator/blob/main/terraform/modules/kdrDemo/cluster.tf#L6) for currency/accuracy, as DO changes it frequently.
* OPTIONAL: K8s [node pool size / resource allocation](https://github.com/mariadb-pieterhumphrey/docker-operator/blob/main/terraform/modules/kdrDemo/cluster.tf#L11) [DO's node pool slugs](https://docs.digitalocean.com/reference/terraform/reference/resources/kubernetes_node_pool/)

(3) Login to DO, and [Create your DO API token](https://cloud.digitalocean.com/account/api/tokens).  For non-production purposes like this, using full permissions is recommeded, choose an expiration timeframe that suits you, then save it somewhere secure on your local machine.  You'll use that in next step. 

(4) copy .env.example to .env , and add your DO API key to the file and save it.

    Copy the .env.example file and add your API KEY from Digital Ocean.

(5) Once you have forked the repositories, you need to build the dockerfile and run the created container. Run these commands while in the same directory as this readme.md file.

    docker compose build --no-cache
    docker compose up -d

(6) To make it easy, there is a `make` script to set up your kubernetes environment. Get the `Container ID` of your running container by using `$ docker ps`.  Then connect to your Docker Container by running:
$ docker exec -it `containerID` /bin/sh

    make init-demo
    make plan-demo
    make apply-demo

(7) Once your Kubernetes Cluster is built you can run the following commands:

    make initialise-helm
    make prepare-operator

(8) You need to wait about 30 seconds for the operator to become available and then you can:

    make install-operator

(9) After three minutes you can check the pods are available:

    kubectl get pods

    NAME                                                READY   STATUS    RESTARTS   AGE
    mariadb-galera-0                                    2/2     Running   0          2m27s
    mariadb-galera-1                                    2/2     Running   0          2m27s
    mariadb-galera-2                                    2/2     Running   0          2m27s
    mariadb-galera-maxscale-0                           1/1     Running   0          63s
    mariadb-operator-cert-controller-5c8f679ff4-d7m5h   1/1     Running   0          4m31s
    mariadb-operator-db9bb8b74-68xhq                    1/1     Running   0          4m31s
    mariadb-operator-webhook-555dc947cd-nvvgj           1/1     Running   0          4m31s

(10) You should now have a fully running Kubernetes Cluster with a MariaDB database environment. 
To install the application run:

    make install-photo-pvc

(11) After a few minutes you can get the services information and connect:

    kubectl get svc 

(12) Find the maxscale-gui IP and connect to it via the IP address:8989 --> mariadb-operator / MaxScale11!

You will also find the service IP address for the Application.

### destroy

The destroy command will delete the infrastructure. This is important, if you have finished using it, to stop getting charged. But please note, some resources such as Load Balancers and Storage will remain. Clearly, do not run this until you have finished.

`make destroy-demo`

If you are running the destroy command, it will ask you to confirm by typing `yes` at the prompt.
Alternatively, go to the Digital Ocean console and delete the K8s cluster from the web console, checking yes when prompted to cascade delete the associated resources.

### Contributing to this project

<!--- If your README is long or you have some specific process or steps you want contributors to follow, consider creating a separate CONTRIBUTING.md file--->
To contribute to this repository, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin my-helm-repo/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation
on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

### Contact

If you want to contact me you can reach me at kesterriley@hotmail.com.

### License

<!--- If you're not sure which open license to use see https://choosealicense.com/--->

This project uses the following license: [MIT](https://github.com/mariadb-kester/docker-operator/blob/main/LICENSE).

### Disclaimer

Whilst, I might currently work for MariaDB, this work was originally created before my employment by MariaDB and any development to these scripts is done strictly in my own time. It is therefore not endorsed, supported by or recommend by MariaDB. 
