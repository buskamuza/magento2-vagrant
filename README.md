# Vagrant for Magento 2 Environment

Use this Vagrant configuration to get Magento compatible VM. It also links your Magento 2 folder to a folder on the VM and installs the application, so you'll get application ready to work with.

The current Vagrant configuration performs the following:

1. Runs Ubunty box
2. Installs and configures all software necessary for Magento 2
3. Links your `../magento2` folder to `/var/www/magento2` folder on VM
  1. Linked via Samba for Windows and via NFS for others
4. Runs `composer install` in Magento 2 folder
5. Installs the Magento 2 application
  1. Deploys static view files for better performance

## Usage

If you never used Vagrant before, read [Vagrant Docs](https://docs.vagrantup.com/v2/)

You need to install:
- Vagrant
- VirtualBox (used by the current configuration)

To install, configure and run the Magento VM, you need to launch virtualbox and then execute the following via command line:

```
cd vagrant.magento2 # empty folder for the Vagrant configuration
git clone https://github.com/buskamuza/magento2-vagrant.git .
vagrant up
```

### Magento 2 Folder

By default Vagrant assumes that your Magento 2 code base is located in `../magento2` folder relatively to your vagrant folder (`vagrant.magento2` in the above example).

If your Magento code base is located in different place, update the following line in `Vagrantfile`:
```
@magento2_path='../magento2'
```

### Hostname

Hostname of the Magento application is determined from hostname of the VM defined in the `Vagrantfile`:
```
config.vm.hostname = "magento2.ce.dev"
```

Change this value in the `Vagrantfile`, if you want to use different hostname.

If by some reason, Vagrant can't determine hostname of the VM, it will use its IP address (also specified in `Vagrantfile`).

Also you need to update your system `hosts` file with a record that links IP address and hostname of the VM.
For the following `Vagrantfile`
```
...
config.vm.network :private_network, ip: '192.168.10.12'
config.vm.hostname = "magento2.ce.dev"
...
```
Specify the following in your `hosts` file:
```
192.168.10.12    magento2.dev
```

### GitHub Limitations

Be aware that you may encounter GitHub limits on the number of downloads (used by Composer to download Magento dependencies).

These limits may significantly slow down the installation since all of the libraries will be cloned from GitHub repositories instead of downloaded as ZIP archives. In the worst case, these limitations may even terminate the installation.

If you have a GitHub account, you can bypass these limitations by using an OAuth token in the Composer configuration. See [API rate limit and OAuth tokens](https://getcomposer.org/doc/articles/troubleshooting.md#api-rate-limit-and-oauth-tokens) for more information.

For the Vagrant configuration you may specify your token in `local.config/github.oauth.token` file after cloning the repository. The file is a basic text file and is ignored by Git, so you'll need to create it yourself. Simply write your OAuth token in this file making sure to avoid any empty spaces, and it will be read during deployment. You should see the following message in the Vagrant log:
```
Installing GitHub OAuth token from /vagrant/local.config/github.oauth.token
```

## After Installation

Upon a successful installation, you'll see the location and URL of the newly-installed Magento 2 application:
```
Installed Magento application in /var/www/magento2
Access front-end at http://magento2.ce.dev/
Access back-end at http://magento2.ce.dev/admin/
```

`/var/www/magento2` is a path to your Magento installation on the VM.

## Additional Information

```
db host: localhost (not accessible remotely)
db user/password: magento/magento
db name: magento

also available db user/password: root/password

Magento admin user/password: admin/iamtheadmin
```

## Skip Magento 2 Installation

### Skip Installation for Running VM
By default, when you run `vagrant provision`, it installs Magento 2 application.
If you want to skip it, use the following command instead:
```
vagrant provision --provision-with=bootstrap
```

### Skip Installation for New VM
By default, when you run `vagrant up` for the first time, it installs Magento 2 application.
Due to a Vagrant bug, `--provision-with` option doesn't work correctly with `vagrant up`.
If you want to setup only environment without installed application, comment the following line in `Vagrantfile`:
 ```
config.vm.provision "install", type: "shell", path: "install.sh"
 ```
 
Now you can run `vagrant up`, as usual. Magento 2 application will not be installed.

## Troubleshooting

If the installation terminates at any time, you can run it again using the following command:
```
vagrant provision
```

## Removing the Installation

If the installation terminates at any time, or you want to get rid of the VM, you can use 

``` 
vagrant destroy
```
from inside the Magento 2 product folder.

## Samba Issues on Windows

Vagrant doesn't remove shared folders when you destroy a VM. It also doesn't use already existing shared folders.
So, if you start installation multiple times, you may get multiple shared folders for the same folder.
Review list of shared folders via `net share` and remove unnecessary ones using `net share NAME /delete` command.
See [Vagrant SMB](https://docs.vagrantup.com/v2/synced-folders/smb.html for more information.)

## Related Repositories

Vagrant for [magento/magento2](https://github.com/magento/magento2):
- https://github.com/alankent/vagrant-magento2-apache-base
- https://github.com/ryanstreet/magento2-vagrant
- https://github.com/rgranadino/mage2_vagrant

Additionally, I'd like to thank the authors of the above repositories as they provided me with some ideas for a better implementation of the Vagrant configuration.
