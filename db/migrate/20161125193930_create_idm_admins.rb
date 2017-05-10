class CreateIdmAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :idm_admins do |t|
      t.string :rardesign
      t.integer :ruleemail
      t.integer :usarules
      t.string :jmlcomplex
      t.integer :addlcomplex
      t.integer :addlmod
      t.integer :addlsimple
      t.string :fcomplex
      t.integer :otbplatform
      t.integer :otbappl
      t.integer :otbticket
      t.integer :custticket
      t.string :pwmgt
      t.string :async
      t.integer :targets
      t.integer :fgtpass
      t.boolean :pret
      t.boolean :psync
      t.boolean :wdesk
      t.integer :astrans
      t.integer :usonboard
      t.integer :cswfpm
      t.integer :cswfba
      t.integer :cswfcon

      t.timestamps
    end
  end
end
