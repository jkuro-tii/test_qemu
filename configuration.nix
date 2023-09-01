              boot.kernelPatches = [
                {
                  name = "JK's driver";
                  patch = ./missing.patch #somDefinition."${cfg.somType}".passthrough-patch;
                }
	      ];