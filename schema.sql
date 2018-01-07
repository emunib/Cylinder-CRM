CREATE SCHEMA global;

CREATE TABLE global.industries(
  industry_id bigserial primary key,
  industry_name varchar(255)
);

create schema crmuser;

CREATE TABLE crmuser.roles(
  role_id bigserial primary key,
  role varchar(20)
);

INSERT INTO crmuser.roles VALUES (DEFAULT, 'ADMIN'), (DEFAULT, 'USER');

CREATE TABLE crmuser.accounts(
  account_id bigserial primary key,
  email varchar(500) unique,
  password varchar(250),
  first_name varchar(100),
  last_name varchar(100),
  is_enabled boolean,
  role_id bigint references crmuser.roles(role_id) on delete restrict
);

INSERT INTO crmuser.accounts VALUES(DEFAULT,
                                    'admin@admin.com',
                                   '$2a$12$fauk6pkAF7fRPyUh8lCu8u9U17Fa0KqHS6SwHXL2xt4WQwC8Z/08G',
                                   'admin',
                                   'admin',
                                   true,
                                   1
                                 );

CREATE SCHEMA lead;

CREATE TABLE lead.comments(
  comment_id bigserial PRIMARY KEY,
  account_id bigint NOT NULL references crmuser.accounts(account_id),
  date_created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  message text
);

CREATE TABLE lead.statuses(
  status_id bigserial PRIMARY KEY,
  descriptor varchar(250)
);

INSERT INTO lead.statuses VALUES (DEFAULT, 'Attempt To Contact'),
                                 (DEFAULT, 'Contacted'),
                                 (DEFAULT, 'Junk Lead'),
                                 (DEFAULT, 'Lost Lead');


CREATE TABLE lead.sources(
  source_id bigserial PRIMARY KEY,
  descriptor varchar(250)
);

INSERT INTO lead.sources VALUES (DEFAULT, 'Advertisment'),
                                (DEFAULT, 'Cold Call'),
                                (DEFAULT, 'Employee Reference'),
                                (DEFAULT, 'External Reference'),
                                (DEFAULT, 'Public Relations'),
                                (DEFAULT, 'Trade Show'),
                                (DEFAULT, 'Web Form'),
                                (DEFAULT, 'Search Engine'),
                                (DEFAULT, 'Facebook'),
                                (DEFAULT, 'Twitter'),
                                (DEFAULT, 'Google Plus');

CREATE TABLE lead.addresses(
  address_id bigserial PRIMARY KEY,
  apartment_number varchar(50),
  street varchar(250),
  city varchar(250),
  prov_state varchar(250),
  country varchar(250),
  zip_postal varchar(25),
  po_box varchar(25)
);

CREATE TABLE lead.emails(
  email_id bigserial PRIMARY KEY,
  email varchar(250)
);

CREATE TABLE lead.details(
  lead_id bigserial PRIMARY KEY,
  first_name varchar(250),
  last_name varchar(250) NOT NULL,
  phone varchar(30),
  mobile varchar(30),
  status_id bigint references lead.statuses(status_id) on update cascade on delete restrict,
  company_name varchar(250),
  title varchar(250),
  source_id bigint references lead.sources(source_id) on update cascade on delete restrict,
  industry_id bigint references global.industries(industry_id) on update cascade on delete restrict,
  twitter varchar(50),
  address_id bigint references lead.addresses(address_id) on delete restrict,
  primary_email_id bigint references lead.emails(email_id) on delete restrict,
  secondary_email_id bigint references lead.emails(email_id) on delete restrict,
  owner_id bigint references crmuser.accounts(account_id) on delete set null,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);

CREATE TABLE lead.comment_lookups(
  comment_id bigint references lead.comments(comment_id) on delete cascade,
  lead_id bigint references lead.details(lead_id) on delete cascade
);

create schema product;

CREATE TABLE product.categories(
  category_id bigserial PRIMARY KEY,
  descriptor varchar(100)
);

INSERT INTO product.categories VALUES (DEFAULT, 'Service'),
                                      (DEFAULT, 'Industrial'),
                                      (DEFAULT, 'Software'),
                                      (DEFAULT, 'Hardware'),
                                      (DEFAULT, 'Compeitition');

CREATE TABLE product.details(
    product_id bigserial PRIMARY KEY,
    code varchar(50),
    name varchar(250) NOT NULL,
    is_active boolean NOT NULL DEFAULT false,
    category_id bigint references product.categories(category_id),
    sales_start timestamp,
    sales_end timestamp,
    support_start timestamp,
    support_end timestamp,
    unit_price money,
    taxable bool,
    commission_rate_percent integer check(commission_rate_percent >= 0 AND commission_rate_percent <= 100),
    qty_in_stock bigint check(qty_in_stock >= 0),
    qty_in_order bigint check(qty_in_order >= 0),
    qty_in_demand bigint check(qty_in_demand >= 0),
    description text,
    created timestamp DEFAULT CURRENT_TIMESTAMP,
    created_by bigint references crmuser.accounts(account_id),
    last_modified timestamp DEFAULT CURRENT_TIMESTAMP,
    last_modified_by_id bigint references crmuser.accounts(account_id),
    owner_id bigint references crmuser.accounts(account_id)
);

CREATE SCHEMA account;

CREATE TABLE account.emails(
  email_id bigserial PRIMARY KEY,
  email varchar(250)
);

CREATE TABLE account.addresses(
  address_id bigserial PRIMARY KEY,
  apartment_number varchar(50),
  street varchar(250),
  city varchar(250),
  prov_state varchar(250),
  country varchar(250),
  zip_postal varchar(25),
  po_box varchar(25)
);

CREATE TABLE account.comments(
  comment_id bigserial PRIMARY KEY,
  date_created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  message text
);

CREATE TABLE account.type(
  type_id bigserial PRIMARY KEY,
  descriptor varchar(100)
);

INSERT INTO account.type VALUES (DEFAULT, 'Analyst'),
                                (DEFAULT, 'Customer'),
                                (DEFAULT, 'Investor'),
                                (DEFAULT, 'Partner'),
                                (DEFAULT, 'Press'),
                                (DEFAULT, 'Compeitor');
CREATE TABLE account.details(
  account_id bigserial PRIMARY KEY,
  name varchar(250) NOT NULL,
  rating float,
  phone varchar(30),
  other_phone varchar(30),
  fax varchar(30),
  parent_id bigint references account.details(account_id) on delete set null,
  type_id bigint references account.type(type_id) on delete restrict,
  ticker_symbol varchar(10),
  website varchar(100),
  number_of_employees integer check(number_of_employees > 0),
  billing_address_id bigint references account.addresses(address_id) on delete restrict,
  shipping_address_id bigint references account.addresses(address_id) on delete restrict,
  primary_email_id bigint references account.emails(email_id) on delete restrict,
  secondary_email_id bigint references account.emails(email_id) on delete restrict,
  owner_id bigint references crmuser.accounts(account_id) on delete set null,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);

CREATE SCHEMA contact;

CREATE TABLE contact.emails(
  email_id bigserial PRIMARY KEY,
  email varchar(250)
);

CREATE TABLE contact.addresses(
  address_id bigserial PRIMARY KEY,
  apartment_number varchar(50),
  street varchar(250),
  city varchar(250),
  prov_state varchar(250),
  country varchar(250),
  zip_postal varchar(25),
  po_box varchar(25)
);

CREATE TABLE contact.comments(
  comment_id bigserial PRIMARY KEY,
  account_id bigint NOT NULL references crmuser.accounts(account_id) on delete set null,
  date_created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  message text
);

CREATE TABLE contact.details(
  contact_id bigserial PRIMARY KEY,
  first_name varchar(250),
  last_name varchar(250),
  account_id bigint references account.details(account_id) on delete set null,
  department varchar(250),
  phone varchar(30),
  other_phone varchar(30),
  mobile varchar(30),
  fax varchar(30),
  date_of_birth date,
  assistant_id bigint references contact.details(contact_id) on delete set null,
  title varchar(100),
  report_to_id bigint references contact.details(contact_id) on delete set null,
  skype varchar(250),
  twitter varchar(100),
  mailing_address_id bigint references contact.addresses(address_id) on delete restrict,
  other_address_id bigint references contact.addresses(address_id) on delete restrict,
  primary_email_id bigint references contact.emails(email_id) on delete restrict,
  secondary_email_id bigint references contact.emails(email_id) on delete restrict,
  owner_id bigint references crmuser.accounts(account_id) on delete set null,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);

CREATE TABLE contact.comment_lookups(
  comment_id bigint references contact.comments(comment_id) on delete cascade,
  contact_id bigint references contact.details(contact_id) on delete cascade,
  PRIMARY KEY(comment_id, contact_id)
);

CREATE SCHEMA deal;

CREATE TABLE deal.types(
  type_id bigserial PRIMARY KEY,
  descriptor varchar(250)
);

INSERT INTO deal.types VALUES (DEFAULT, 'New'), (DEFAULT, 'Existing');

CREATE TABLE deal.stages(
  stage_id bigserial PRIMARY KEY,
  descriptor varchar(250)
);


INSERT INTO deal.stages VALUES (DEFAULT, 'Qualification'),
                               (DEFAULT, 'Needs Analysis'),
                               (DEFAULT, 'Value Proposition'),
                               (DEFAULT, 'Identify Descision Makers'),
                               (DEFAULT, 'Proposal/Quote'),
                               (DEFAULT, 'Review'),
                               (DEFAULT, 'Closed Won'),
                               (DEFAULT, 'Closed Lost'),
                               (DEFAULT, 'Closed Lost To Competition');

CREATE TABLE deal.comments(
  comment_id bigserial PRIMARY KEY,
  account_id bigint NOT NULL references crmuser.accounts(account_id) on delete set null,
  date_created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  message text
);

CREATE TABLE deal.details(
  deal_id bigserial PRIMARY KEY,
  owner_id bigint NOT NULL references crmuser.accounts(account_id) on delete set null,
  type_id bigint references deal.types(type_id) on delete restrict,
  stage_id bigint references deal.stages(stage_id) on delete restrict,
  expected_rev money,
  contact_id bigint references contact.details(contact_id) on delete set null,
  account_id bigint references account.details(account_id) on delete set null,
  amount_earned money,
  closing_date date,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);


CREATE TABLE deal.comment_lookups(
  comment_id bigint references deal.comments(comment_id),
  deal_id bigint references deal.details(deal_id),
  PRIMARY KEY(comment_id, deal_id)
);

CREATE SCHEMA sale;

CREATE TABLE sale.purchase_orders(
  purchase_order_id bigserial primary key,
  contact_id bigint references contact.details(contact_id) on delete set null,
  account_id bigint references account.details(account_id) on delete restrict,
  owner_id bigint references crmuser.accounts(account_id) on delete set null,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);

CREATE TABLE sale.purchase_product_lookups(
  purchase_product_id bigserial primary key,
  purchase_order_id bigint references sale.purchase_orders(purchase_order_id) on delete cascade,
  product_id bigint references product.details(product_id) on delete restrict,
  quantity bigint,
  discount numeric(5,5)
);

CREATE TABLE sale.quotes(
  quote_id bigserial primary key,
  account_id bigint references account.details(account_id) on delete restrict,
  contact_id bigint references contact.details(contact_id) on delete set null,
  owner_id bigint references crmuser.accounts(account_id) on delete set null,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);

CREATE TABLE sale.quote_product_lookup(
  quote_product_id bigserial primary key,
  product_id bigint references product.details(product_id) on delete restrict,
  quote_id bigint references sale.quotes(quote_id) on delete cascade,
  quantity bigint,
  discount numeric(5,5)
);

CREATE TABLE sale.addresses(
  address_id bigserial PRIMARY KEY,
  apartment_number varchar(50),
  street varchar(250),
  city varchar(250),
  prov_state varchar(250),
  country varchar(250),
  zip_postal varchar(25),
  po_box varchar(25)
);

CREATE TABLE sale.contract(
  contract_id bigserial primary key,
  contact_title varchar(50),
  contract text
);

CREATE TABLE sale.sales_orders(
  sale_order_id bigserial primary key,
  billing_address_id bigint references sale.addresses(address_id) on delete set null,
  shipping_address_id bigint references sale.addresses(address_id) on delete set null,
  contact_id bigint references contact.details(contact_id) on delete set null,
  account_id bigint references account.details(account_id) on delete restrict,
  quote_id bigint references sale.quotes(quote_id) on delete set null,
  tax_percent numeric(5,5),
  invoice_number bigint unique,
  contract_id bigint references sale.contract(contract_id) on delete restrict,
  owner_id bigint references crmuser.accounts(account_id) on delete set null,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);

CREATE TABLE sale.sale_product_lookups(
  sale_product_id bigserial primary key,
  sale_order_id bigint references sale.sales_orders(sale_order_id) on delete cascade,
  product_id bigint references product.details(product_id) on delete restrict,
  quantity bigint,
  discount numeric(5,5)
);

CREATE SCHEMA ticket;

CREATE TABLE ticket.statuses(
  status_id bigserial PRIMARY KEY,
  descriptor varchar(250)
);

CREATE TABLE ticket.case_origins(
  origin_id bigserial PRIMARY KEY,
  descriptor varchar(250)
);

CREATE TABLE ticket.comments(
  comment_id bigserial PRIMARY KEY,
  account_id bigint NOT NULL references crmuser.accounts(account_id),
  date_created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  message text
);


CREATE TABLE ticket.details(
  ticket_id bigserial PRIMARY KEY,
  status_id bigint references ticket.statuses(status_id) on delete restrict,
  origin_id bigint references ticket.case_origins(origin_id) on delete restrict,
  contact_id bigint references contact.details(contact_id) on delete set null,
  phone varchar(30),
  product_id bigint references product.details(product_id) on delete set null,
  owner_id bigint references crmuser.accounts(account_id) on delete set null,
  subject varchar(100),
  account_id bigint references account.details(account_id) on delete set null,
  email varchar(250),
  description text,
  solution text,
  created_by bigint references crmuser.accounts(account_id) on delete set null,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_modified timestamp,
  last_modified_by_id bigint references crmuser.accounts(account_id) on delete set null
);

CREATE TABLE ticket.comment_lookups(
  comment_id bigint references ticket.comments(comment_id) on delete cascade,
  ticket_id bigint references ticket.details(ticket_id) on delete cascade,
  PRIMARY KEY(comment_id, ticket_id)
);

CREATE TABLE account.comment_lookups(
  comment_id bigint references account.comments(comment_id) on delete cascade,
  account_id bigint references account.details(account_id) on delete cascade,
  PRIMARY KEY(comment_id, account_id)
);

CREATE TABLE account.deal_lookups(
  deal_id bigint references deal.details(deal_id) on delete cascade,
  account_id bigint references account.details(account_id) on delete cascade,
  PRIMARY KEY(deal_id, account_id)
);

CREATE TABLE account.case_lookups(
  ticket_id bigint references ticket.details(ticket_id) on delete cascade,
  account_id bigint references account.details(account_id) on delete cascade,
  PRIMARY KEY(ticket_id, account_id)
);

CREATE TABLE account.contact_lookups(
  contact_id bigint references contact.details(contact_id) on delete cascade,
  account_id bigint references account.details(account_id) on delete cascade,
  PRIMARY KEY(contact_id, account_id)
);

CREATE OR REPLACE FUNCTION update_case_lookup()
RETURNS trigger as $$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    IF NEW.account_id IS NULL THEN
      DELETE FROM account.case_lookups WHERE account_id = OLD.account_id AND ticket_id = OLD.ticket_id;
    ELSIF OLD.account_id IS NULL THEN
      INSERT INTO account.case_lookups SELECT NEW.ticket_id,NEW.account_id WHERE NOT EXISTS(SELECT 1 FROM account.case_lookups WHERE account_id = NEW.account_id AND ticket_id = NEW.ticket_id);
    ELSIF NEW.account_id != OLD.account_id THEN
        UPDATE account.case_lookups SET account_id = NEW.account_id WHERE account_id = OLD.account_id AND ticket_id = OLD.ticket_id;
    END IF;
  ELSIF (TG_OP='INSERT') THEN
    IF NEW.account_id IS NOT NULL THEN
      INSERT INTO account.case_lookups SELECT NEW.ticket_id,NEW.account_id WHERE NOT EXISTS(SELECT 1 FROM account.case_lookups WHERE account_id = NEW.account_id AND ticket_id = NEW.ticket_id);
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_deal_lookup()
RETURNS trigger as $$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    IF NEW.account_id IS NULL THEN
      DELETE FROM account.deal_lookups WHERE account_id = OLD.account_id AND ticket_id = OLD.deal_id;
    ELSIF OLD.account_id IS NULL THEN
      INSERT INTO account.deal_lookups SELECT NEW.deal_id,NEW.account_id WHERE NOT EXISTS(SELECT 1 FROM account.deal_lookups WHERE account_id = NEW.account_id AND deal_id = NEW.deal_id);
    ELSIF NEW.account_id != OLD.account_id THEN
        UPDATE account.deal_lookups SET account_id = NEW.account_id WHERE account_id = OLD.account_id AND deal_id = OLD.deal_id;
    END IF;
  ELSIF (TG_OP='INSERT') THEN
    IF NEW.account_id IS NOT NULL THEN
      INSERT INTO account.deal_lookups SELECT NEW.deal_id,NEW.account_id WHERE NOT EXISTS(SELECT 1 FROM account.deal_lookups WHERE account_id = NEW.account_id AND deal_id = NEW.deal_id);
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_contact_lookup()
RETURNS trigger as $$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    IF NEW.account_id IS NULL THEN
      DELETE FROM account.contact_lookups WHERE account_id = OLD.account_id AND ticket_id = OLD.contact_id;
    ELSIF OLD.account_id IS NULL THEN
      INSERT INTO account.contact_lookups SELECT NEW.contact_id,NEW.account_id WHERE NOT EXISTS(SELECT 1 FROM account.contact_lookups WHERE account_id = NEW.account_id AND ticket_id = NEW.contact_id);
    ELSIF NEW.account_id != OLD.account_id THEN
        UPDATE account.contact_lookups SET account_id = NEW.account_id WHERE account_id = OLD.account_id AND contact_id = OLD.contact_id;
    END IF;
  ELSIF (TG_OP='INSERT') THEN
    IF NEW.account_id IS NOT NULL THEN
      INSERT INTO account.contact_lookups SELECT NEW.contact_id,NEW.account_id WHERE NOT EXISTS(SELECT 1 FROM account.contact_lookups WHERE account_id = NEW.account_id AND contact_id = NEW.contact_id);
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_case_update
  AFTER UPDATE OR INSERT ON ticket.details
  FOR EACH ROW
  EXECUTE PROCEDURE update_case_lookup();

CREATE TRIGGER on_deals_update
  AFTER UPDATE OR INSERT ON deal.details
  FOR EACH ROW
  EXECUTE PROCEDURE update_deal_lookup();


CREATE TRIGGER on_contact_update
  AFTER UPDATE OR INSERT ON contact.details
  FOR EACH ROW
  EXECUTE PROCEDURE update_contact_lookup();

/*
* Session table definitions taken from:
* https://github.com/spring-projects/spring-session/blob/1.3.x/spring-session/src/main/resources/org/springframework/session/jdbc/schema-postgresql.sql#L2
*/
CREATE TABLE SPRING_SESSION (
	SESSION_ID CHAR(36) NOT NULL,
	CREATION_TIME BIGINT NOT NULL,
	LAST_ACCESS_TIME BIGINT NOT NULL,
	MAX_INACTIVE_INTERVAL INT NOT NULL,
	PRINCIPAL_NAME VARCHAR(100),
	CONSTRAINT SPRING_SESSION_PK PRIMARY KEY (SESSION_ID)
);

CREATE INDEX SPRING_SESSION_IX1 ON SPRING_SESSION (LAST_ACCESS_TIME);

CREATE TABLE SPRING_SESSION_ATTRIBUTES (
	SESSION_ID CHAR(36) NOT NULL,
	ATTRIBUTE_NAME VARCHAR(200) NOT NULL,
	ATTRIBUTE_BYTES BYTEA NOT NULL,
	CONSTRAINT SPRING_SESSION_ATTRIBUTES_PK PRIMARY KEY (SESSION_ID, ATTRIBUTE_NAME),
	CONSTRAINT SPRING_SESSION_ATTRIBUTES_FK FOREIGN KEY (SESSION_ID) REFERENCES SPRING_SESSION(SESSION_ID) ON DELETE CASCADE
);

CREATE INDEX SPRING_SESSION_ATTRIBUTES_IX1 ON SPRING_SESSION_ATTRIBUTES (SESSION_ID);
