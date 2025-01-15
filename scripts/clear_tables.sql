DO $$
  BEGIN
    -- Отключаем проверку внешних ключей
    EXECUTE 'SET session_replication_role = ''replica''';

    -- Очищаем таблицы
    TRUNCATE TABLE public.vet_specialties RESTART IDENTITY CASCADE;
    TRUNCATE TABLE public.visits RESTART IDENTITY CASCADE;
    TRUNCATE TABLE public.pets RESTART IDENTITY CASCADE;
    TRUNCATE TABLE public.owners RESTART IDENTITY CASCADE;
    TRUNCATE TABLE public.types RESTART IDENTITY CASCADE;
    TRUNCATE TABLE public.specialties RESTART IDENTITY CASCADE;
    TRUNCATE TABLE public.vets RESTART IDENTITY CASCADE;

    -- Включаем проверку внешних ключей
    EXECUTE 'SET session_replication_role = ''origin''';
  END $$;
