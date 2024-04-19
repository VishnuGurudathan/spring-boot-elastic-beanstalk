package org.example.domain.service;

import org.example.domain.exceptions.AccountNotFoundException;
import org.example.domain.model.Account;
import org.example.domain.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AccountServiceImpl implements AccountService {

    @Value("${dummy.type}")
    private String dummyType;


    private final AccountRepository accountRepository;

    public AccountServiceImpl(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    /**
     * {@inheritDoc}
     * <p/>
     * Dummy method for testing purposes.
     *
     * @param number The account number. Set 0000 to get an {@link AccountNotFoundException}
     */
    @Override
    public Account findOne(String number) throws AccountNotFoundException {
        if(number.equals("0000")) {
            throw new AccountNotFoundException("0000");
        }

        Account account = accountRepository.findByNumber(number);
        if(account == null){
            account = createAccountByNumber(number);
        }

        return account;
    }

    @Override
    public Account createAccountByNumber(String number) {
        Account account = new Account();
        account.setNumber(number);
        return accountRepository.save(account);
    }

    public String getDummyType() {
        return dummyType;
    }

    public void setDummyType(String dummyType) {
        this.dummyType = dummyType;
    }
}
