package org.example.domain.autoconfigure;

import org.example.domain.service.AccountServiceImpl;
import org.example.domain.repository.AccountRepository;
import org.example.domain.service.AccountService;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

//@Configuration
//@ComponentScan("org.example.web.repository")
public class DomainAutoConfiguration {

    public DomainAutoConfiguration() {}
//
//    @Bean
//    @ConditionalOnMissingBean(type = "accountService")
//    AccountService accountService(AccountRepository accountRepository) {
//        return new AccountServiceImpl(accountRepository);
//    }
}
