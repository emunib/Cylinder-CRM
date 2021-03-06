package com.cylinder.contacts.model;

import com.cylinder.RespositoryTests;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.Assert.assertEquals;

public class ContactRepositoryTests extends RespositoryTests {

    @Autowired
    ContactRepository contactRepository;

    @Before
    public void initData() {
        Contact contact = new Contact();
        contact.setLastName("Saget");
        contactRepository.save(contact);
        contact = new Contact();
        contact.setLastName("Testy");
        contactRepository.save(contact);
        contact = new Contact();
        contact.setLastName("Testo");
        contactRepository.save(contact);
    }

    @Test
    public void testExistsBy() {
        Long id = new Long("1");
        boolean isExisting = contactRepository.existsByContactId(id);
        assertEquals(isExisting, true);
        id = new Long("4");
        isExisting = contactRepository.existsByContactId(id);
        assertEquals(isExisting, false);
    }

    @Test
    public void testDeleteById() {
        Long id = new Long("4");
        boolean isExisting = contactRepository.existsByContactId(id);
        assertEquals(isExisting, true);
        contactRepository.deleteByContactId(id);
        isExisting = contactRepository.existsByContactId(id);
        assertEquals(isExisting, false);
    }

}
