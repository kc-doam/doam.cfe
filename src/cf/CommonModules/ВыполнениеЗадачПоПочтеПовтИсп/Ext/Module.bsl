﻿////////////////////////////////////////////////////////////////////////////////
// Выполнение задач по почте (повт. исп.).
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает идентификатор задачи
//
// Параметры:
//  Задача - ЗадачаСсылка.ЗадачаИсполнителя - ссылка на задачу.
//
// Возвращаемое значение:
//  УникальныйИдентификатор
//
Функция ИдентификаторЗадачи(Задача) Экспорт
	
	Возврат Задача.УникальныйИдентификатор();
	
КонецФункции

// Возвращает длину темы ответного письма.
//
// Возвращаемое значение:
//  Число
//
Функция ДлинаТемыОтветногоПисьма() Экспорт
	
	Возврат Константы.ДлинаТемыОтветногоПисьма.Получить();
	
КонецФункции

#КонецОбласти