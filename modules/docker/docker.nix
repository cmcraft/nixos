{ ... }:
{
  virtualisation.docker = {
    enable = false;
    storageDriver = "btrfs";

    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [ "1.1.1.1" "1.1.1.2" ];
        registry-mirrors = [ "https://mirror.gcr.io" ];
        data-root = "/persist/docker";
      };
    };

    daemon.settings = {
      data-root = "/docker";
    };
  };

  virtualisation.arion = {
    backend = "docker";
    projects = {
      redbot = {
        serviceName = "redbot";
        settings = {
          imports = [
            ./containers/redbot.nix
          ];
        };
      };
    };
  };
}