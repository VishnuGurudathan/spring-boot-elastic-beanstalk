package org.example.web.controller;

import org.example.domain.model.Account;
import org.example.domain.service.AccountService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class WelcomeController {
    @Value("${application.message:Hello World}")
    private String message = "Hello World";


    private final AccountService accountService;

    public WelcomeController(AccountService accountService) {
        this.accountService = accountService;
    }

    @RequestMapping("/")
    public String welcome(Model model,
                          @RequestParam(value = "accountId", required = false, defaultValue = "1") String id) {
        // Trying to obtain 23 account
        Account account = accountService.findOne(id);
        if(account == null){
            // If there's some problem creating account, return show view with error status
            model.addAttribute("message", "Error getting account!");
            model.addAttribute("account", "");
            return "welcome/show";
        }

        // Return show view with 23 account info
        String accountInfo = "Your account number is ".concat(account.getNumber());
        model.addAttribute("message", this.message);
        model.addAttribute("account", accountInfo);
        return "welcome/show";
    }

//    @RequestMapping("foo")
//    public String foo(Map<String, Object> model) {
//        throw new RuntimeException("Foo");
//    }

}
