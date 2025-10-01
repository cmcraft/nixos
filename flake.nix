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

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    swww = {
      url = "github:LGFae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, impermanence, hyprland, disko,... }@inputs: 
  {
    nixosConfigurations.SURFBoard = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/SURFBoard/configuration.nix
        {
            imports = [ home-manager.nixosModules.home-manager ];
            
            home-manager.users.cmcraft =
              { ... }:
              {
                imports = [
                  impermanence.homeManagerModules.impermanence
                  ./home/impermanence.nix # Your home-manager impermanence-configuration
                ];
              };
          }
        inputs.disko.nixosModules.disko
      ];
    };
  };
}
