{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wpaperd = {
      url = "github:danyspin97/wpaperd";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-strix-halo.url = "github:hellas-ai/nix-strix-halo";

    comfyui-nix.url = "github:utensils/comfyui-nix";

    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, impermanence, hyprland, stylix, wpaperd, sops-nix, disko, nix-strix-halo, comfyui-nix, hermes-agent, ... }@inputs: 
  {
    nixosConfigurations.SURFBoard = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/SURFBoard/configuration.nix
        stylix.nixosModules.stylix
        impermanence.nixosModules.impermanence
        {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager.users.cmcraft =
              { ... }:
              {
                imports = [
                  ./home/home-impermanence.nix # Your home-manager impermanence-configuration
                ];
              };
          }
        sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
      ];
    };
    nixosConfigurations.romulus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/romulus/configuration.nix
        stylix.nixosModules.stylix
        impermanence.nixosModules.impermanence
        {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager.users.cmcraft =
              { ... }:
              {
                imports = [
                  ./home/home-impermanence.nix # Your home-manager impermanence-configuration
                ];
              };
          }
        sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
      ];
    };
    nixosConfigurations.remus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/remus/configuration.nix
        stylix.nixosModules.stylix
        impermanence.nixosModules.impermanence
        {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager.users.cmcraft =
              { ... }:
              {
                imports = [
                  ./home/home-impermanence.nix # Your home-manager impermanence-configuration
                ];
              };
          }
        sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
      ];
    };

    nixosConfigurations.vivi = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/vivi/configuration.nix
        nix-strix-halo.nixosModules.default
        hermes-agent.nixosModules.default
        stylix.nixosModules.stylix
        impermanence.nixosModules.impermanence
        nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
        
        # Import the overlay
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ 
            comfyui-nix.overlays.default
          ];
        })

        {
            imports = [ home-manager.nixosModules.home-manager ];
            home-manager.users.cmcraft =
              { ... }:
              {
                imports = [
                  ./home/home-impermanence.nix # Your home-manager impermanence-configuration
                ];
              };
          }
        sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
      ];
    };
  };
}
