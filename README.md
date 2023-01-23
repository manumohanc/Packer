# What is Packer?

Packer is an open source tool for creating virtual machine images for deployment.

Packer is lightweight in nature and runs on all major operating systems, and it has some tremendous performance, creating identical virtual images for multiple platforms in parallel from a single configuration file.

Packer comes with support to build images for Amazon EC2, Google Compute Engine , Microsoft Azure, Virtual Box, VMware, Cloudstack, DigitalOcean, Docker, and more.

# Key Packer Terminologies


- Artifacts are the results of a single build, and are usually a set of IDs or files to represent a machine image. Every builder produces a single artifact. As an example, in the case of the Amazon EC2 builder, the artifact is a set of AMI IDs (one per region). For the VMware builder, the artifact is a directory of files comprising the created virtual machine.

- Builds are a single task that eventually produces an image for a single platform. Multiple builds run in parallel. Example usage in a sentence: “The Packer build produced an AMI to run our web application.” Or: “Packer is running the builds now for VMware, AWS, and VirtualBox.”

- Builders are components of Packer that are able to create a machine image for a single platform. Builders read in some configuration and use that to run and generate a machine image. A builder is invoked as part of a build in order to create the actual resulting images. Example builders include VirtualBox, VMware, and Amazon EC2. Builders can be created and added to Packer in the form of plugins.

- Commands are sub-commands for the packer program that perform some job. An example command is “build”, which is invoked as packer build. Packer ships with a set of commands out of the box in order to define its command-line interface.

- Post-processors are components of Packer that take the result of a builder or another post-processor and process that to create a new artifact. Examples of post-processors are compress to compress artifacts, upload to upload artifacts, etc.

- Provisioners are components of Packer that install and configure software within a running machine prior to that machine being turned into a static image. They perform the major work of making the image contain useful software. Example provisioners include shell scripts, Chef, Puppet, etc.

- Templates are JSON files which define one or more builds by configuring the various components of Packer. Packer is able to read a template and use that information to create multiple machine images in parallel.

# Installing Hashicorp Packer

Packer may be installed in the following ways by visiting the official packer downloads page: https://www.packer.io/downloads.html

```sh
$ wget https://releases.hashicorp.com/packer/1.4.5/packer_1.4.5_linux_amd64.zip
$ unzip packer_1.4.5_linux_amd64.zip
$ sudo mv packer /usr/local/bin/
$ packer version
Packer v1.4.5
```

#Validate
Before we take this template and build an image from it, let’s validate the template by running the folowing command 

```sh
$packer validate main.pkr.hcl
```
Expected output 
```sh
Template validated successfully.
```

#Build
Next, let’s build the image from the template.

With a properly validated template, it is time to build your first image. This is done by running the following command

```sh
$ packer build main.pkr.hcl
```

On running this command, Packer outputs resources details such ID of the machine image. 

Now we pull the AMI details into the terraform using the datasoure aws_ami and use it to build the instances. 
