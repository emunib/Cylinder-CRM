package com.cylinder.sales.model;

import com.cylinder.RespositoryTests;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.Assert.assertEquals;

public class SalesOrderRepositoryTests extends RespositoryTests {

    @Autowired
    SalesOrderRepository salesOrderRepository;

    @Before
    public void initData() {
        SalesOrder salesOrder = new SalesOrder();
        salesOrderRepository.save(salesOrder);
        salesOrder = new SalesOrder();
        salesOrderRepository.save(salesOrder);
        salesOrder = new SalesOrder();
        salesOrderRepository.save(salesOrder);
    }

    @Test
    public void testExistsBy() {
        Long id = new Long("1");
        boolean isExisting = salesOrderRepository.existsById(id);
        assertEquals(isExisting, true);
        id = new Long("4");
        isExisting = salesOrderRepository.existsById(id);
        assertEquals(isExisting, false);
    }

    @Test
    public void testDeleteById() {
        Long id = new Long("4");
        boolean isExisting = salesOrderRepository.existsById(id);
        assertEquals(isExisting, true);
        salesOrderRepository.deleteById(id);
        isExisting = salesOrderRepository.existsById(id);
        assertEquals(isExisting, false);
    }

}
