package org.hucs;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Scanner;

import static org.hucs.Constants.ANSI_BLUE;
import static org.hucs.Constants.ANSI_RESET;

public abstract class AbstractMenu implements Menu {
    protected Scanner scanner = new Scanner(System.in);
    protected Map<Integer, Menu> subMenus = new LinkedHashMap<>();
    protected String title;

    public AbstractMenu(String title) {
        this.title = title;
    }

    public void addOption(int option, Menu menu) {
        subMenus.put(option, menu);
    }

    @Override
    public void show() {
        System.out.println(ANSI_BLUE + "\n=== " + title + " ===" + ANSI_RESET);
        int i = 1;
        for (Map.Entry<Integer, Menu> entry : subMenus.entrySet()) {
            System.out.println(entry.getKey() + ". " + (entry.getValue()).getTitle());
        }
        System.out.println("0. Back/Exit");
        System.out.print("Choose an option: ");
    }

    @Override
    public void execute() {
        while (true) {
            show();
            String input = scanner.nextLine();
            if (input.equals("0")) break;

            try {
                int choice = Integer.parseInt(input);
                Menu selected = subMenus.get(choice);
                if (selected != null) {
                    selected.execute();
                } else {
                    System.out.println("Invalid option.");
                }
            } catch (NumberFormatException e) {
                System.out.println("Please enter a valid number.");
            }
        }
    }

    public String getTitle() {
        return title;
    }
}

