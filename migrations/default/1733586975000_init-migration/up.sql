SET check_function_bodies = false;
CREATE SCHEMA boorran;
CREATE SCHEMA boorranv2;
CREATE SCHEMA boorranv3;
CREATE SCHEMA inventory;
CREATE FUNCTION boorran."set_current_timestamp_updatedAt"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updatedAt" = NOW();
  RETURN _new;
END;
$$;
CREATE FUNCTION boorran.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE FUNCTION inventory.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE boorran."Attendances" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "staffId" uuid NOT NULL,
    "ipAddress" text,
    type text NOT NULL,
    status text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "expiredAt" timestamp with time zone NOT NULL,
    location text
);
CREATE TABLE boorran."CancelRequests" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "delivererId" uuid NOT NULL,
    remark text NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    "isReturn" boolean DEFAULT false NOT NULL,
    "reappointDateTime" timestamp with time zone,
    "approverId" uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE boorran."ChartOfAccounts" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    account_type text NOT NULL,
    account_name text NOT NULL,
    account_number text,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb,
    financial_type text NOT NULL
);
CREATE TABLE boorran."CommissionDisbursements" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    commission numeric NOT NULL,
    "userId" uuid,
    "itemCount" integer NOT NULL,
    "vendorName" text NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "vendorId" uuid,
    status text DEFAULT 'pending'::text NOT NULL
);
CREATE TABLE boorran."Commissions" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    price numeric NOT NULL,
    cost numeric NOT NULL,
    commission numeric NOT NULL,
    "deliveryRevenue" numeric NOT NULL,
    total numeric NOT NULL,
    "collectionId" numeric NOT NULL,
    "disbursementId" uuid,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "collectionName" text NOT NULL,
    "orderItemId" uuid,
    discount numeric DEFAULT '0'::numeric,
    "productTitle" text NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now(),
    qty integer DEFAULT 1 NOT NULL
);
CREATE TABLE boorran."Configs" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE boorran."CustomerAddress" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "shopifyCustomerId" text NOT NULL,
    "customerId" uuid NOT NULL,
    address text NOT NULL,
    city text,
    province text,
    country text,
    zip text,
    phone text,
    "isDefault" boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    "shopifyAddressId" text NOT NULL,
    "firstName" text,
    "lastName" text,
    "provinceId" uuid,
    "districtId" uuid,
    "communeId" uuid,
    location text
);
CREATE TABLE boorran."Customers" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "firstName" text,
    "lastName" text,
    "shopifyCustomerId" text,
    email text,
    phone text,
    address text,
    "pageId" text,
    psid text,
    last_interaction_at timestamp with time zone
);
CREATE TABLE boorran."Disbursements" (
    id integer NOT NULL,
    "requestorId" uuid,
    "acceptorId" uuid,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now(),
    "paymentMethod" text,
    accepted boolean DEFAULT false,
    transfered boolean DEFAULT false,
    note text,
    total numeric DEFAULT 0 NOT NULL,
    "paymentType" text DEFAULT 'cash'::text NOT NULL
);
CREATE SEQUENCE boorran."Disbursements_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE boorran."Disbursements_id_seq" OWNED BY boorran."Disbursements".id;
CREATE TABLE boorran."Discounts" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "variantIds" text[] NOT NULL,
    type text NOT NULL,
    "endedAt" timestamp with time zone,
    "salesChannels" text[],
    "productId" uuid NOT NULL,
    title text,
    amount numeric,
    "createdAt" timestamp with time zone DEFAULT now(),
    "startedAt" timestamp with time zone,
    "onlinePaymentAmount" numeric,
    "onlinePaymentType" text,
    collection text
);
CREATE TABLE boorran."Logs" (
    id bigint NOT NULL,
    field text,
    value text,
    "orderId" uuid,
    "staffId" uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
CREATE SEQUENCE boorran."Logs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE boorran."Logs_id_seq" OWNED BY boorran."Logs".id;
CREATE TABLE boorran."Notifications" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    message text NOT NULL,
    start timestamp with time zone NOT NULL,
    "end" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    description text,
    image text,
    type text,
    channel text,
    metadata jsonb
);
CREATE TABLE boorran."OrderItems" (
    "itemId" numeric,
    "itemTitle" text,
    "variantId" numeric,
    "variantTitle" text,
    quantity integer,
    discount numeric,
    "unitPrice" numeric,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "orderId" uuid
);
CREATE TABLE boorran."OrderLogs" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    action text NOT NULL,
    value text,
    message text NOT NULL,
    "staffId" uuid NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE boorran."Orders" (
    source text DEFAULT 'shopify'::text,
    "staffId" uuid,
    "subTotal" numeric,
    discount numeric,
    status text,
    "deliveryStatus" text DEFAULT 'Pending'::text,
    "paymentMethod" text,
    "deliveryPrice" numeric,
    "grandTotal" numeric,
    note text,
    "createdAt" timestamp with time zone,
    "orderAddress" text,
    "deliveryDestination" text,
    "deliverBy" text,
    "paymentReceiverId" uuid,
    "paymentReceivedDate" timestamp with time zone,
    "isCollectedByAdmin" boolean DEFAULT false,
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "itemsPrice" numeric,
    "taxPrice" numeric,
    "shopifyOrderId" text NOT NULL,
    "shopifyOrderNumber" text NOT NULL,
    "customerId" uuid,
    "boorranDeliveryPrice" numeric,
    "boorranGrandTotal" numeric,
    "refundDeliveryToStaff" text DEFAULT 'not_yet'::text,
    "delivererId" uuid,
    chat_url text,
    "refundById" uuid,
    "paymentRequested" boolean DEFAULT false,
    "refundRequested" boolean DEFAULT false,
    "packStatus" text DEFAULT 'Pending'::text,
    "packBy" uuid,
    "addressId" uuid,
    location text,
    "deliveryDate" timestamp with time zone,
    schedule boolean DEFAULT false NOT NULL,
    "exchangedOrderId" uuid,
    "packMessageId" text,
    "deliveryOrderId" numeric,
    "isPre_order" boolean DEFAULT false
);
CREATE TABLE boorran."PaymentMethodRequests" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "orderId" uuid NOT NULL,
    "paymentMethod" text NOT NULL,
    image text NOT NULL,
    "delivererId" uuid NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    "telegramMessageId" text
);
CREATE VIEW boorran."PendingCommissionDisbursements" AS
 SELECT "Commissions"."collectionId",
    max("Commissions"."collectionName") AS "collectionName",
    sum("Commissions".commission) AS commission,
    sum("Commissions".qty) AS "itemCount"
   FROM boorran."Commissions"
  WHERE ("Commissions"."disbursementId" IS NULL)
  GROUP BY "Commissions"."collectionId";
CREATE TABLE boorran."ProductImages" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    source text NOT NULL,
    "productId" text,
    "shopifyImageId" text,
    "new_productId" numeric
);
CREATE TABLE boorran."ProductVariants" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "itemId" text,
    "productId" uuid,
    title text,
    price numeric,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    "imageId" text,
    quantity integer,
    "new_itemId" numeric
);
CREATE TABLE boorran."Products" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "itemId" text,
    title text,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    "new_itemId" numeric
);
CREATE TABLE boorran."SubDisbursements" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "disbursmentId" integer,
    "paymentReceiverId" uuid,
    "paymentMethod" text,
    total numeric,
    "refundById" uuid,
    "shippingPrice" numeric,
    "driverCharge" numeric,
    "orderId" uuid,
    "shopifyOrderNumber" text,
    "shopifyOrderId" text,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now()
);
CREATE TABLE boorran."Transactions" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    date date NOT NULL,
    transaction_type text NOT NULL,
    account text NOT NULL,
    category text NOT NULL,
    amount numeric NOT NULL,
    reviewed boolean DEFAULT false NOT NULL,
    requestor_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    description text NOT NULL
);
CREATE TABLE boorranv2.featured_image (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    src text NOT NULL,
    alt_text text,
    height integer,
    original_src text NOT NULL,
    width integer,
    transformed_src text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    shopify_id text
);
CREATE TABLE boorranv2.inventory (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    variant_id uuid NOT NULL,
    shopify_id text NOT NULL,
    quantity integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE boorranv2.product_options (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    shopify_id text NOT NULL,
    name text NOT NULL,
    "values" text[] NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE boorranv2.products (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    shopify_id text NOT NULL,
    title text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE boorranv2.variants (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    shopify_id text NOT NULL,
    title text NOT NULL,
    price numeric NOT NULL,
    sku text,
    inventory integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    image text
);
CREATE TABLE boorranv3.collections (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL
);
CREATE TABLE boorranv3.featured_images (
    id text NOT NULL,
    product_id text,
    src text NOT NULL,
    alt_text text,
    width integer,
    height integer,
    original_src text,
    transformed_src text
);
CREATE TABLE boorranv3.images (
    id text NOT NULL,
    original_src text NOT NULL,
    src text NOT NULL,
    transformed_src text,
    alt_text text,
    product_id text
);
CREATE TABLE boorranv3.product_options (
    id text NOT NULL,
    product_id text,
    name text NOT NULL,
    "values" jsonb NOT NULL
);
CREATE TABLE boorranv3.product_variants (
    id text NOT NULL,
    product_id text,
    title text NOT NULL,
    price numeric(10,2) NOT NULL,
    sku text NOT NULL,
    inventory_quantity integer,
    image_src text,
    image_transformed_src text
);
CREATE TABLE boorranv3.products (
    id text NOT NULL,
    collection_id text,
    title text NOT NULL,
    handle text NOT NULL,
    product_type text,
    status text,
    max_variant_price numeric(10,2),
    min_variant_price numeric(10,2),
    vendor text
);
CREATE TABLE inventory.categories (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    parent_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE inventory.inventory_items (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    cost numeric NOT NULL,
    sku text,
    qty numeric NOT NULL,
    product_variant_id uuid NOT NULL,
    location_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE inventory.locations (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    phone text,
    address text,
    city text,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE inventory.product_categories (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    category_id uuid NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE inventory.product_option_types (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    title text NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE inventory.product_option_values (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    product_option_type_id uuid NOT NULL,
    title text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    "position" integer DEFAULT 1 NOT NULL
);
CREATE TABLE inventory.product_variants (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    weight numeric DEFAULT 0 NOT NULL,
    price numeric NOT NULL,
    cost numeric,
    product_id uuid NOT NULL,
    options jsonb NOT NULL,
    inventory_qty integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE inventory.products (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    status text NOT NULL,
    description text,
    tags text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    price numeric DEFAULT 0 NOT NULL,
    compared_at_price numeric
);
CREATE TABLE public."Enums" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    type text,
    text text,
    value text,
    metadata jsonb
);
CREATE TABLE public."Sessions" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "userId" uuid,
    "createdAt" timestamp with time zone DEFAULT now(),
    "expiredAt" timestamp with time zone,
    metadata jsonb
);
CREATE TABLE public."Users" (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text,
    phone text,
    email text,
    store text,
    role text,
    pin text,
    metadata jsonb,
    photo text,
    "createdAt" timestamp with time zone DEFAULT now(),
    "activationStatus" boolean DEFAULT true,
    "notificationToken" text
);
CREATE TABLE public.accounts (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    type text NOT NULL,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    access_token text,
    expires_at integer,
    token_type text,
    scope text,
    id_token text,
    session_state text,
    "userId" uuid NOT NULL
);
CREATE TABLE public.boorranv3_products (
    id text NOT NULL,
    title text NOT NULL,
    handle text,
    vendor text,
    product_type text,
    status text,
    max_variant_price numeric,
    min_variant_price numeric,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.provider_type (
    value text NOT NULL
);
CREATE TABLE public.sessions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "sessionToken" text NOT NULL,
    "userId" uuid NOT NULL,
    expires timestamp with time zone NOT NULL
);
CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text,
    email text NOT NULL,
    "emailVerified" timestamp with time zone,
    image text
);
CREATE TABLE public.verification_tokens (
    token text NOT NULL,
    identifier text NOT NULL,
    expires timestamp with time zone NOT NULL
);
ALTER TABLE ONLY boorran."Disbursements" ALTER COLUMN id SET DEFAULT nextval('boorran."Disbursements_id_seq"'::regclass);
ALTER TABLE ONLY boorran."Logs" ALTER COLUMN id SET DEFAULT nextval('boorran."Logs_id_seq"'::regclass);
ALTER TABLE ONLY boorran."Attendances"
    ADD CONSTRAINT "Attendances_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."CancelRequests"
    ADD CONSTRAINT "CancelRequests_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."ChartOfAccounts"
    ADD CONSTRAINT "ChartOfAccounts_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."CommissionDisbursements"
    ADD CONSTRAINT "CommissionDisbursements_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Commissions"
    ADD CONSTRAINT "Commissions_orderItemId_key" UNIQUE ("orderItemId");
ALTER TABLE ONLY boorran."Commissions"
    ADD CONSTRAINT "Commissions_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Configs"
    ADD CONSTRAINT "Configs_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."CustomerAddress"
    ADD CONSTRAINT "CustomerAddress_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."CustomerAddress"
    ADD CONSTRAINT "CustomerAddress_shopifyAddressId_key" UNIQUE ("shopifyAddressId");
ALTER TABLE ONLY boorran."Customers"
    ADD CONSTRAINT "Customers_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Customers"
    ADD CONSTRAINT "Customers_psid_key" UNIQUE (psid);
ALTER TABLE ONLY boorran."Customers"
    ADD CONSTRAINT "Customers_shopifyCustomerId_key" UNIQUE ("shopifyCustomerId");
ALTER TABLE ONLY boorran."Disbursements"
    ADD CONSTRAINT "Disbursements_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Discounts"
    ADD CONSTRAINT "Discounts_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Logs"
    ADD CONSTRAINT "Logs_orderId_field_key" UNIQUE ("orderId", field);
ALTER TABLE ONLY boorran."Logs"
    ADD CONSTRAINT "Logs_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Notifications"
    ADD CONSTRAINT "Notifications_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."OrderItems"
    ADD CONSTRAINT "OrderItems_id_key" UNIQUE (id);
ALTER TABLE ONLY boorran."OrderItems"
    ADD CONSTRAINT "OrderItems_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."OrderLogs"
    ADD CONSTRAINT "OrderLogs_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_shopifyOrderId_key" UNIQUE ("shopifyOrderId");
ALTER TABLE ONLY boorran."PaymentMethodRequests"
    ADD CONSTRAINT "PaymentMethodRequests_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."ProductImages"
    ADD CONSTRAINT "ProductImages_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."ProductImages"
    ADD CONSTRAINT "ProductImages_shopifyImageId_key" UNIQUE ("shopifyImageId");
ALTER TABLE ONLY boorran."ProductVariants"
    ADD CONSTRAINT "ProductVariants_itemId_productId_key" UNIQUE ("itemId", "productId");
ALTER TABLE ONLY boorran."ProductVariants"
    ADD CONSTRAINT "ProductVariants_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Products"
    ADD CONSTRAINT "Products_itemId_key" UNIQUE ("itemId");
ALTER TABLE ONLY boorran."Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."SubDisbursements"
    ADD CONSTRAINT "SubDisbursements_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorran."Transactions"
    ADD CONSTRAINT "Transactions_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY boorranv2.featured_image
    ADD CONSTRAINT featured_image_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv2.featured_image
    ADD CONSTRAINT featured_image_product_id_key UNIQUE (product_id);
ALTER TABLE ONLY boorranv2.featured_image
    ADD CONSTRAINT featured_image_shopify_id_key UNIQUE (shopify_id);
ALTER TABLE ONLY boorranv2.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv2.inventory
    ADD CONSTRAINT inventory_shopify_id_key UNIQUE (shopify_id);
ALTER TABLE ONLY boorranv2.product_options
    ADD CONSTRAINT product_options_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv2.product_options
    ADD CONSTRAINT product_options_shopify_id_key UNIQUE (shopify_id);
ALTER TABLE ONLY boorranv2.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv2.products
    ADD CONSTRAINT products_shopify_id_key UNIQUE (shopify_id);
ALTER TABLE ONLY boorranv2.variants
    ADD CONSTRAINT variants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv2.variants
    ADD CONSTRAINT variants_shopify_id_key UNIQUE (shopify_id);
ALTER TABLE ONLY boorranv3.images
    ADD CONSTRAINT boorranv3_images_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv3.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv3.featured_images
    ADD CONSTRAINT featured_images_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv3.product_options
    ADD CONSTRAINT product_options_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv3.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY boorranv3.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.inventory_items
    ADD CONSTRAINT inventory_items_sku_key UNIQUE (sku);
ALTER TABLE ONLY inventory.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.product_option_types
    ADD CONSTRAINT product_option_types_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.product_option_values
    ADD CONSTRAINT product_option_values_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);
ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_slug_key UNIQUE (slug);
ALTER TABLE ONLY public."Enums"
    ADD CONSTRAINT "Enums_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Sessions"
    ADD CONSTRAINT "Sessions_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key" UNIQUE (email);
ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.boorranv3_products
    ADD CONSTRAINT boorranv3_products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.provider_type
    ADD CONSTRAINT provider_type_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY ("sessionToken");
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (token);
CREATE TRIGGER "set_boorran_CancelRequests_updated_at" BEFORE UPDATE ON boorran."CancelRequests" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_CancelRequests_updated_at" ON boorran."CancelRequests" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_boorran_ChartOfAccounts_updated_at" BEFORE UPDATE ON boorran."ChartOfAccounts" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_ChartOfAccounts_updated_at" ON boorran."ChartOfAccounts" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_boorran_CommissionDisbursements_updatedAt" BEFORE UPDATE ON boorran."CommissionDisbursements" FOR EACH ROW EXECUTE PROCEDURE boorran."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_boorran_CommissionDisbursements_updatedAt" ON boorran."CommissionDisbursements" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER "set_boorran_Commissions_updatedAt" BEFORE UPDATE ON boorran."Commissions" FOR EACH ROW EXECUTE PROCEDURE boorran."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_boorran_Commissions_updatedAt" ON boorran."Commissions" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER "set_boorran_Configs_updated_at" BEFORE UPDATE ON boorran."Configs" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_Configs_updated_at" ON boorran."Configs" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_boorran_CustomerAddress_updated_at" BEFORE UPDATE ON boorran."CustomerAddress" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_CustomerAddress_updated_at" ON boorran."CustomerAddress" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_boorran_Disbursements_updatedAt" BEFORE UPDATE ON boorran."Disbursements" FOR EACH ROW EXECUTE PROCEDURE boorran."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_boorran_Disbursements_updatedAt" ON boorran."Disbursements" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER "set_boorran_Logs_updated_at" BEFORE UPDATE ON boorran."Logs" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_Logs_updated_at" ON boorran."Logs" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_boorran_Notifications_updated_at" BEFORE UPDATE ON boorran."Notifications" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_Notifications_updated_at" ON boorran."Notifications" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_boorran_OrderLogs_updatedAt" BEFORE UPDATE ON boorran."OrderLogs" FOR EACH ROW EXECUTE PROCEDURE boorran."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_boorran_OrderLogs_updatedAt" ON boorran."OrderLogs" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER "set_boorran_PaymentMethodRequests_updated_at" BEFORE UPDATE ON boorran."PaymentMethodRequests" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_PaymentMethodRequests_updated_at" ON boorran."PaymentMethodRequests" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_boorran_ProductVariants_updatedAt" BEFORE UPDATE ON boorran."ProductVariants" FOR EACH ROW EXECUTE PROCEDURE boorran."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_boorran_ProductVariants_updatedAt" ON boorran."ProductVariants" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER "set_boorran_Products_updatedAt" BEFORE UPDATE ON boorran."Products" FOR EACH ROW EXECUTE PROCEDURE boorran."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_boorran_Products_updatedAt" ON boorran."Products" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER "set_boorran_SubDisbursements_updatedAt" BEFORE UPDATE ON boorran."SubDisbursements" FOR EACH ROW EXECUTE PROCEDURE boorran."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_boorran_SubDisbursements_updatedAt" ON boorran."SubDisbursements" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER "set_boorran_Transactions_updated_at" BEFORE UPDATE ON boorran."Transactions" FOR EACH ROW EXECUTE PROCEDURE boorran.set_current_timestamp_updated_at();
COMMENT ON TRIGGER "set_boorran_Transactions_updated_at" ON boorran."Transactions" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_categories_updated_at BEFORE UPDATE ON inventory.categories FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_categories_updated_at ON inventory.categories IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_inventory_items_updated_at BEFORE UPDATE ON inventory.inventory_items FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_inventory_items_updated_at ON inventory.inventory_items IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_locations_updated_at BEFORE UPDATE ON inventory.locations FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_locations_updated_at ON inventory.locations IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_product_categories_updated_at BEFORE UPDATE ON inventory.product_categories FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_product_categories_updated_at ON inventory.product_categories IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_product_option_types_updated_at BEFORE UPDATE ON inventory.product_option_types FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_product_option_types_updated_at ON inventory.product_option_types IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_product_option_values_updated_at BEFORE UPDATE ON inventory.product_option_values FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_product_option_values_updated_at ON inventory.product_option_values IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_product_variants_updated_at BEFORE UPDATE ON inventory.product_variants FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_product_variants_updated_at ON inventory.product_variants IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_inventory_products_updated_at BEFORE UPDATE ON inventory.products FOR EACH ROW EXECUTE PROCEDURE inventory.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_inventory_products_updated_at ON inventory.products IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY boorran."Attendances"
    ADD CONSTRAINT "Attendances_staffId_fkey" FOREIGN KEY ("staffId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."CancelRequests"
    ADD CONSTRAINT "CancelRequests_approverId_fkey" FOREIGN KEY ("approverId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."CancelRequests"
    ADD CONSTRAINT "CancelRequests_delivererId_fkey" FOREIGN KEY ("delivererId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."CancelRequests"
    ADD CONSTRAINT "CancelRequests_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES boorran."Orders"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."CommissionDisbursements"
    ADD CONSTRAINT "CommissionDisbursements_user_id_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Commissions"
    ADD CONSTRAINT "Commissions_disbursementId_fkey" FOREIGN KEY ("disbursementId") REFERENCES boorran."CommissionDisbursements"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Commissions"
    ADD CONSTRAINT "Commissions_orderItemId_fkey" FOREIGN KEY ("orderItemId") REFERENCES boorran."OrderItems"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."CustomerAddress"
    ADD CONSTRAINT "CustomerAddress_communeId_fkey" FOREIGN KEY ("communeId") REFERENCES "Enums"."Communes"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY boorran."CustomerAddress"
    ADD CONSTRAINT "CustomerAddress_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES boorran."Customers"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."CustomerAddress"
    ADD CONSTRAINT "CustomerAddress_districtId_fkey" FOREIGN KEY ("districtId") REFERENCES "Enums"."Districts"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY boorran."CustomerAddress"
    ADD CONSTRAINT "CustomerAddress_provinceId_fkey" FOREIGN KEY ("provinceId") REFERENCES "Enums"."Provinces"(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY boorran."Disbursements"
    ADD CONSTRAINT "Disbursements_acceptor_fkey" FOREIGN KEY ("acceptorId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Disbursements"
    ADD CONSTRAINT "Disbursements_requestor_fkey" FOREIGN KEY ("requestorId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Discounts"
    ADD CONSTRAINT "Discounts_productId_fkey" FOREIGN KEY ("productId") REFERENCES boorran."Products"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."Logs"
    ADD CONSTRAINT "Logs_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES boorran."Orders"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."Logs"
    ADD CONSTRAINT "Logs_staffId_fkey" FOREIGN KEY ("staffId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY boorran."OrderItems"
    ADD CONSTRAINT "OrderItems_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES boorran."Orders"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."OrderLogs"
    ADD CONSTRAINT "OrderLogs_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES boorran."Orders"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."OrderLogs"
    ADD CONSTRAINT "OrderLogs_staffId_fkey" FOREIGN KEY ("staffId") REFERENCES public."Users"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_addressId_fkey" FOREIGN KEY ("addressId") REFERENCES boorran."CustomerAddress"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES boorran."Customers"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_deliverer_fkey" FOREIGN KEY ("delivererId") REFERENCES public."Users"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_exchangedOrderId_fkey" FOREIGN KEY ("exchangedOrderId") REFERENCES boorran."Orders"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_packBy_fkey" FOREIGN KEY ("packBy") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_paymentReceiverId_fkey" FOREIGN KEY ("paymentReceiverId") REFERENCES public."Users"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_refundById_fkey" FOREIGN KEY ("refundById") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Orders"
    ADD CONSTRAINT "Orders_staffId_fkey" FOREIGN KEY ("staffId") REFERENCES public."Users"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."PaymentMethodRequests"
    ADD CONSTRAINT "PaymentMethodRequests_delivererId_fkey" FOREIGN KEY ("delivererId") REFERENCES public."Users"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."PaymentMethodRequests"
    ADD CONSTRAINT "PaymentMethodRequests_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES boorran."Orders"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."ProductImages"
    ADD CONSTRAINT "ProductImages_productId_fkey" FOREIGN KEY ("productId") REFERENCES boorran."Products"("itemId") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."ProductVariants"
    ADD CONSTRAINT "ProductVariants_imageId_fkey" FOREIGN KEY ("imageId") REFERENCES boorran."ProductImages"("shopifyImageId") ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."ProductVariants"
    ADD CONSTRAINT "ProductVariants_productId_fkey" FOREIGN KEY ("productId") REFERENCES boorran."Products"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."SubDisbursements"
    ADD CONSTRAINT "SubDisbursements_disbursmentId_fkey" FOREIGN KEY ("disbursmentId") REFERENCES boorran."Disbursements"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."SubDisbursements"
    ADD CONSTRAINT "SubDisbursements_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES boorran."Orders"(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY boorran."SubDisbursements"
    ADD CONSTRAINT "SubDisbursements_paymentReceiverId_fkey" FOREIGN KEY ("paymentReceiverId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."SubDisbursements"
    ADD CONSTRAINT "SubDisbursements_refundById_fkey" FOREIGN KEY ("refundById") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY boorran."Transactions"
    ADD CONSTRAINT "Transactions_requestor_id_fkey" FOREIGN KEY (requestor_id) REFERENCES public."Users"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY boorranv2.featured_image
    ADD CONSTRAINT featured_image_product_id_fkey FOREIGN KEY (product_id) REFERENCES boorranv2.products(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv2.inventory
    ADD CONSTRAINT inventory_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES boorranv2.variants(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv2.product_options
    ADD CONSTRAINT product_options_product_id_fkey FOREIGN KEY (product_id) REFERENCES boorranv2.products(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv2.variants
    ADD CONSTRAINT variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES boorranv2.products(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv3.featured_images
    ADD CONSTRAINT featured_images_product_id_fkey FOREIGN KEY (product_id) REFERENCES boorranv3.products(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv3.images
    ADD CONSTRAINT images_product_id_fkey2 FOREIGN KEY (product_id) REFERENCES boorranv3.products(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv3.product_options
    ADD CONSTRAINT product_options_product_id_fkey FOREIGN KEY (product_id) REFERENCES boorranv3.products(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv3.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES boorranv3.products(id) ON DELETE CASCADE;
ALTER TABLE ONLY boorranv3.products
    ADD CONSTRAINT products_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES boorranv3.collections(id) ON DELETE CASCADE;
ALTER TABLE ONLY inventory.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES inventory.categories(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.inventory_items
    ADD CONSTRAINT inventory_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES inventory.locations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.inventory_items
    ADD CONSTRAINT inventory_items_product_variant_id_fkey FOREIGN KEY (product_variant_id) REFERENCES inventory.product_variants(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.product_categories
    ADD CONSTRAINT product_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES inventory.categories(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.product_categories
    ADD CONSTRAINT product_categories_product_id_fkey FOREIGN KEY (product_id) REFERENCES inventory.products(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.product_option_types
    ADD CONSTRAINT product_option_types_product_id_fkey FOREIGN KEY (product_id) REFERENCES inventory.products(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.product_option_values
    ADD CONSTRAINT product_option_values_product_id_fkey FOREIGN KEY (product_id) REFERENCES inventory.products(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.product_option_values
    ADD CONSTRAINT product_option_values_product_option_type_id_fkey FOREIGN KEY (product_option_type_id) REFERENCES inventory.product_option_types(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY inventory.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES inventory.products(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_type_fkey FOREIGN KEY (type) REFERENCES public.provider_type(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT "accounts_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE CASCADE;
