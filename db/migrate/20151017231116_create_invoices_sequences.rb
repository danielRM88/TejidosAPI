class CreateInvoicesSequences < ActiveRecord::Migration
  def up
    execute 'CREATE SEQUENCE INVOICES_NUMBER_SQ
               INCREMENT 1
               MINVALUE 1
               MAXVALUE 9223372036854775807
               START 1
               CACHE 1;
             ALTER TABLE INVOICES_NUMBER_SQ
               OWNER TO postgres;'

    execute 'CREATE SEQUENCE INVOICES_NOI_NUMBER_SQ
                INCREMENT 1
                MINVALUE 1
                MAXVALUE 9223372036854775807
                START 1
                CACHE 1;
              ALTER TABLE INVOICES_NOI_NUMBER_SQ
                OWNER TO postgres;'
  end

  def down
    execute 'DROP SEQUENCE INVOICES_NOI_NUMBER_SQ;'
    execute 'DROP SEQUENCE INVOICES_NUMBER_SQ;'
  end
end
