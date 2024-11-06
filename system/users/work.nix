{ pkgs, ... }:

{
  users.users.work.packages = with pkgs; [
    beekeeper-studio # SQL client
    nodejs_18 # Node package manager
    nodePackages.firebase-tools # Manage, and deploy your Firebase project from the command line
    slack # Desktop client for Slack
    watchman # Watches files and takes action when they change
  ];
}
