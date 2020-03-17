require_relative "../config/environment.rb"

class Student

attr_accessor :name, :grade
attr_reader :id
 
def initialize(id=nil, name, grade)
@id = id
@name = name
@grade = grade
end
 def self.create_table
sql =  <<-SQL
CREATE TABLE IF NOT EXISTS students (
id INTEGER PRIMARY KEY,
name TEXT,
grade INTEGER
)
SQL
DB[:conn].execute(sql)
end

# 	def update
# 	sql = "UPDATE songs SET name = ?, grade = ? WHERE name = ?"
# 	DB[:conn].execute(sql, self.name, self.grade, self.name)
# 	end
 def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

def save
    if self.id
      self.update
    else
      sql = <<-SQL 
        INSERT INTO students (name, grade)
        VALUES (?,?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
 
def self.create(name, grade)
student = self.new(name, grade)
student.save
student
end
 
# 	33. def self.create(name:, album:)
# 	34. song = Song.new(name, album)
# 	35. song.save
# 	36. song
# end
 
 
def self.find_by_name(name)
sql = "SELECT * FROM students WHERE name = ?"
result = DB[:conn].execute(sql, name)[0]
Student.new(result[0], result[1], result[2])
end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end 
# def self.new_from_db(row)
# new_dog = self.new  # self.new is the same as running Song.new
# new_dog.id = row[0]
# new_dog.name =  row[1]
# new_dog.breed = row[2]
# new_dog  # return the newly created instance
# end

  def self.drop_table 
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

end




#this is just an example and is not used
class Song
 
attr_accessor :name, :album
attr_reader :id
 
def initialize(id=nil, name, album)
@id = id
@name = name
@album = album
end
 
def self.create_table
sql =  <<-SQL
CREATE TABLE IF NOT EXISTS songs (
id INTEGER PRIMARY KEY,
name TEXT,
album TEXT
)
SQL
DB[:conn].execute(sql)
end
 
def save
sql = <<-SQL
INSERT INTO songs (name, album)
VALUES (?, ?)
SQL
 
DB[:conn].execute(sql, self.name, self.album)
@id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
end
 
def self.create(name:, album:)
song = Song.new(name, album)
song.save
song
end
 
def self.find_by_name(name)
sql = "SELECT * FROM songs WHERE name = ?"
result = DB[:conn].execute(sql, name)[0]
Song.new(result[0], result[1], result[2])
end
end

