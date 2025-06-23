package org.hucs;

public class OptionMenu implements Menu {
    private String name;

    public OptionMenu(String name) {
        this.name = name;
    }

    @Override
    public void show() {
        System.out.println("Selected: " + name);
    }

    @Override
    public void execute() {
        show();
        System.out.println("Press Enter to return...");
        new Scanner(System.in).nextLine();
    }

    public String getTitle() {
        return name;
    }
}

