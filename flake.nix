{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, ... }: {
    packages.x86_64-linux = {
      vmware = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          # you can include your own nixos configuration here, i.e.
          # ./configuration.nix
          ({ config, lib, pkgs, ... }:
            {
                config.boot.kernelPatches = [
                {
                  name = "JK's driver";
                  patch = ./missing.patch; #somDefinition."${cfg.somType}".passthrough-patch;
                }
              ];
            }
          )
        ];
        #];
        # config.boot.kernelPatches = [
#          {
#            name = "JK's driver";
#            patch = ./missing.patch; #somDefinition."${cfg.somType}".passthrough-patch;
#          }
#        ];
        # ]];
        format = "vmware";
        
        # optional arguments:
        # explicit nixpkgs and lib:
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        # additional arguments to pass to modules:
        # specialArgs = { myExtraArg = "foobar"; };
        
        # you can also define your own custom formats
        # customFormats = { "myFormat" = <myFormatModule>; ... };
        # format = "myFormat";
      };
      vbox = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "virtualbox";
      };
      iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "iso";
      };
      raw = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "raw";
        modules = [
          {
            config.users.users.root.password = "root";
            config.services.openssh.enable = true;
            config.services.openssh.settings.PermitRootLogin = "yes";
            config.users.allowNoPasswordLogin = true;
            config.users.users.jk.password = "jk";
            config.users.users.jk.group = "jk";
            config.users.users.jk.shell = "/bin/sh";
            config.users.users.jk.isSystemUser = true;
            config.users.users.jk.createHome = true;
            config.users.users.jk.home = "/home/jk";
            config.users.groups.jk = {};

            #config.security.selinux.enable = false;

          }
          ({ config, lib, pkgs, ... }:
            {
                config.environment.systemPackages = with pkgs; [ pciutils gnumake gcc git ];
                config.boot.kernelPackages = pkgs.linuxPackages_5_4;
                config.boot.kernelPatches = [
                {
                  name = "JK's driver";
                  patch = ./0001-ivshmem-driver.patch; #somDefinition."${cfg.somType}".passthrough-patch;
                  extraConfig = ''
                    VIRTIO_PCI n
                  '';
                }
              ];
            }
          )

        ];
      };
    };
  };
}
/*
                    VIRTIO y
                    VIRTIO_PCI  y
                    VIRTIO_BLK y
                    VIRTIO_CONSOLE y
                    EXT4_FS y
                    DRM_BOCHS y
                    DRM y
                    AGP y
*/
