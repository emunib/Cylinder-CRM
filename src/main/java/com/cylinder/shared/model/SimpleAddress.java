package com.cylinder.shared.model;

import javax.persistence.*;
import javax.validation.constraints.Pattern;

@MappedSuperclass
abstract public class SimpleAddress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    protected Long addressId;
    @Column(name = "apartment_number")
    @Pattern(regexp = "(?:[0-9]*\\s?[a-zA-Z]*){1,50}", message = "Please enter a valid apartment number.")
    protected String apartmentNumber;
    @Column(name = "city")
    @Pattern(regexp = "(?:[A-Za-z\\s]){1,250}", message = "Please enter a valid city name.")
    protected String city;
    @Column(name = "street")
    @Pattern(regexp = "[A-Za-z0-9\\s\\.]{1,250}", message = "Please enter a valid street address.")
    protected String streetAddress;
    @Column(name = "prov_state")
    @Pattern(regexp = "[A-Za-z0-9\\s]{1,250}", message = "Please enter a valid state or province.")
    protected String stateProv;
    @Column(name = "country")
    @Pattern(regexp = "(?:[A-Za-z0-9\\s]*){1,250}", message = "Please enter a valid country.")
    protected String country;
    @Column(name = "zip_postal")
    @Pattern(regexp = "(?:[A-Za-z0-9\\s]*){1,25}", message = "Please enter a valid zip or postal code.")
    protected String zipPostal;
    @Column(name = "po_box")
    @Pattern(regexp = "(?:[A-Za-z0-9\\s]*){1,25}", message = "Please enter a valid po box number.")
    protected String poBox;

    public Long getAddressId() {
        return this.addressId;
    }

    public void setAddressId(Long addressId) {
        this.addressId = addressId;
    }

    public String getApartmentNumber() {
        return this.apartmentNumber;
    }

    public void setApartmentNumber(String apartmentNumber) {
        this.apartmentNumber = apartmentNumber;
    }

    public String getCity() {
        return this.city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStreetAddress() {
        return this.streetAddress;
    }

    public void setStreetAddress(String streetAddress) {
        this.streetAddress = streetAddress;
    }

    public String getStateProv() {
        return this.stateProv;
    }

    public void setStateProv(String stateProv) {
        this.stateProv = stateProv;
    }

    public String getPoBox() {
        return this.poBox;
    }

    public void setPoBox(String poBox) {
        this.poBox = poBox;
    }

    public String getZipPostal() {
        return this.zipPostal;
    }

    public void setZipPostal(String zipPostal) {
        this.zipPostal = zipPostal;
    }

    public String getCountry() {
        return this.country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    /*
     * If everything is null then we need to update the class that is dependent on
     * this "class" so that it is null. If one doesn't then we might get a useless
     * record with only nulls in it.
     **/
    public boolean areFieldsNull() {
        return (this.apartmentNumber == null) &&
                (this.city == null) &&
                (this.streetAddress == null) &&
                (this.stateProv == null) &&
                (this.country == null) &&
                (this.zipPostal == null) &&
                (this.poBox == null);
    }

    /*
     * If two address are the same
     **/
    public boolean equals(SimpleAddress simpleAddress) {
        return (this.apartmentNumber == simpleAddress.apartmentNumber) &&
                (this.city == simpleAddress.city) &&
                (this.streetAddress == simpleAddress.streetAddress) &&
                (this.stateProv == simpleAddress.stateProv) &&
                (this.country == simpleAddress.country) &&
                (this.zipPostal == simpleAddress.zipPostal) &&
                (this.poBox == simpleAddress.poBox);
    }
}
