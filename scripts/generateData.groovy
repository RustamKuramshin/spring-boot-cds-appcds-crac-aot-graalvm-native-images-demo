@GrabConfig(systemClassLoader=true)

@Grab(group='org.postgresql', module='postgresql', version='42.2.5')
@Grab(group='com.github.javafaker', module='javafaker', version='1.0.2')

import groovy.transform.Field

import groovy.sql.Sql
import com.github.javafaker.Faker

// Настройки подключения к БД
def dbUrl = 'jdbc:postgresql://localhost:35432/petclinic'
def dbUser = 'petclinic'
def dbPassword = 'petclinic'

def sql = Sql.newInstance(dbUrl, dbUser, dbPassword, 'org.postgresql.Driver')

@Field
def faker = new Faker()

// Функция для генерации данных
void generateTestData(Sql sql) {
    // Генерация данных для таблицы "vets"
    (1..1000).each {
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
    (1..1000).each {
        def vetId = faker.number().numberBetween(1, 1000)
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
    (1..1000).each {
        def firstName = faker.name().firstName()
        def lastName = faker.name().lastName()
        def address = faker.address().streetAddress()
        def city = faker.address().city()
        def telephone = faker.phoneNumber().phoneNumber()
        sql.execute("INSERT INTO owners (first_name, last_name, address, city, telephone) VALUES (?, ?, ?, ?, ?)", [firstName, lastName, address, city, telephone])
    }

    // Генерация данных для таблицы "pets"
    (1..1000).each {
        def name = faker.name().firstName()
        def birthDate = new java.sql.Date(faker.date().birthday().time)
        def typeId = faker.number().numberBetween(1, 10)
        def ownerId = faker.number().numberBetween(1, 1000)
        sql.execute("INSERT INTO pets (name, birth_date, type_id, owner_id) VALUES (?, ?, ?, ?)", [name, birthDate, typeId, ownerId])
    }

    // Генерация данных для таблицы "visits"
    (1..1000).each {
        def petId = faker.number().numberBetween(1, 1000)
        def visitDate = new java.sql.Date(faker.date().past(365, java.util.concurrent.TimeUnit.DAYS).time)
        def description = faker.lorem().sentence()
        sql.execute("INSERT INTO visits (pet_id, visit_date, description) VALUES (?, ?, ?)", [petId, visitDate, description])
    }
}

// Запуск генерации данных
try {
    generateTestData(sql)
    println 'Данные успешно сгенерированы и добавлены в базу данных.'
} catch (Exception e) {
    println "Ошибка при генерации данных: ${e.message}"
} finally {
    sql.close()
}
