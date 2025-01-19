@GrabConfig(systemClassLoader=true)

@Grab(group='org.postgresql', module='postgresql', version='42.2.5')
@Grab(group='com.github.javafaker', module='javafaker', version='1.0.2')

import groovy.transform.Field

import groovy.sql.Sql
import com.github.javafaker.Faker

// Чтение параметра количества записей из аргументов
@Field
def recordCount = args.length > 0 ? args[0].toInteger() : 1000
@Field
def dbNames = args.length > 1 ? args[1].split(',') : ['petclinic']

println "Генерация ${recordCount} записей для баз данных: ${dbNames.join(', ')}."

@Field
def faker = new Faker()

// Функция для генерации данных
void generateTestData(Sql sql, int recordCount) {
    // Генерация данных для таблицы "vets"
    (1..recordCount).each {
        def firstName = faker.name().firstName()
        def lastName = faker.name().lastName()
        sql.execute("INSERT INTO vets (first_name, last_name) VALUES (?, ?)", [firstName, lastName])
    }

    // Генерация данных для таблицы "specialties"
    def specialties = (1..10).collect {
        def specialty = faker.job().title()
        sql.execute("INSERT INTO specialties (name) VALUES (?)", [specialty])
        specialty
    }

    // Генерация данных для таблицы "vet_specialties"
    (1..recordCount).each {
        def vetId = faker.number().numberBetween(1, recordCount)
        def specialtyId = faker.number().numberBetween(1, 10)
        sql.execute("INSERT INTO vet_specialties (vet_id, specialty_id) VALUES (?, ?) ON CONFLICT DO NOTHING", [vetId, specialtyId])
    }

    // Генерация данных для таблицы "types"
    def types = (1..10).collect {
        def typeName = faker.animal().name()
        sql.execute("INSERT INTO types (name) VALUES (?)", [typeName])
        typeName
    }

    // Генерация данных для таблицы "owners"
    (1..recordCount).each {
        def firstName = faker.name().firstName()
        def lastName = faker.name().lastName()
        def address = faker.address().streetAddress()
        def city = faker.address().city()
        def telephone = faker.phoneNumber().phoneNumber()
        sql.execute("INSERT INTO owners (first_name, last_name, address, city, telephone) VALUES (?, ?, ?, ?, ?)", [firstName, lastName, address, city, telephone])
    }

    // Генерация данных для таблицы "pets"
    (1..recordCount).each {
        def name = faker.name().firstName()
        def birthDate = new java.sql.Date(faker.date().birthday().time)
        def typeId = faker.number().numberBetween(1, 10)
        def ownerId = faker.number().numberBetween(1, recordCount)
        sql.execute("INSERT INTO pets (name, birth_date, type_id, owner_id) VALUES (?, ?, ?, ?)", [name, birthDate, typeId, ownerId])
    }

    // Генерация данных для таблицы "visits"
    (1..recordCount).each {
        def petId = faker.number().numberBetween(1, recordCount)
        def visitDate = new java.sql.Date(faker.date().past(365, java.util.concurrent.TimeUnit.DAYS).time)
        def description = faker.lorem().sentence()
        sql.execute("INSERT INTO visits (pet_id, visit_date, description) VALUES (?, ?, ?)", [petId, visitDate, description])
    }
}


// Основной процесс для всех баз данных
dbNames.each { dbName ->
    def dbUrl = "jdbc:postgresql://localhost:35432/${dbName}"
    def dbUser = 'petclinic'
    def dbPassword = 'petclinic'

    println "Подключение к базе данных: ${dbName}."
    def sql = Sql.newInstance(dbUrl, dbUser, dbPassword, 'org.postgresql.Driver')

    try {
        generateTestData(sql, recordCount)
        println "Данные успешно сгенерированы и добавлены в базу данных: ${dbName}."
    } catch (Exception e) {
        println "Ошибка при генерации данных для базы данных ${dbName}: ${e.message}"
    } finally {
        sql.close()
    }
}
