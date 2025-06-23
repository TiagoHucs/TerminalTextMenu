package org.hucs;

public class App {
    public static void main(String[] args) {

        GroupMenu gameMenu = new GroupMenu("GAME MENU");
        gameMenu.addOption(1, new OptionMenu("Start game",new Command("Game started")));
        gameMenu.addOption(2, new OptionMenu("Continue game",new Command("Game continued")));

        GroupMenu settingsMenu = new GroupMenu("SETTINGS");
        settingsMenu.addOption(1, new OptionMenu("Change Language",new Command("Language changed")));
        settingsMenu.addOption(2, new OptionMenu("Change Theme",new Command("Theme changed")));

        GroupMenu mainMenu = new GroupMenu("MAIN MENU");
        mainMenu.addOption(1, gameMenu);
        mainMenu.addOption(2, settingsMenu);

        mainMenu.execute();
        System.out.println("Exiting...");
    }
}

