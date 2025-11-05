{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # swww = {
    #   url = "github:LGFae/swww";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets = {
    #   url = "git+ssh://git@github.com/cmcraft/secrets.git?ref=main&shallow=1";
    #   flake = false;
    # };

    meshtastic = {
      url = "github:nvmd/nixos-meshtastic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, impermanence, hyprland, stylix, wpaperd, sops-nix, disko, meshtastic, ... }@inputs: 
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
                  impermanence.homeManagerModules.impermanence
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
                  impermanence.homeManagerModules.impermanence
                  ./home/home-impermanence.nix # Your home-manager impermanence-configuration
                ];
              };
          }
        sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        meshtastic.nixosModules.meshtastic
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
                  impermanence.homeManagerModules.impermanence
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
