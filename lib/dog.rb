class Dog 
  attr_accessor :name, :breed, :id  
  def initialize(dog_hash, id = nil)
    @name = dog_hash[:name]
    @breed = dog_hash[:breed] 
    @id = id 
  end 
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        bred TEXT
      );
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs;")
  end
  
  def save
      sql = <<-SQL
        INSERT INTO dogs(name, breed)
        VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")[0][0]
      self
  end
  
  def self.create(name:, breed:)
    # binding.pry
    doggie = Dog.new(name: name, breed: breed)
    doggie.save
  end
  
  def self.new_from_db(row)
    doggie = self.new(name: row[1], breed: row[2])
    doggie.id = row[0]
    doggie
  end
  
  def self.find_by_id(id)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE id = ?;
    SQL
    found_dog = self.new_from_db(DB[:conn].execute(sql, id)[0])
  end
  
  def self.find_or_create_by(name:, breed:)
    
  end
end