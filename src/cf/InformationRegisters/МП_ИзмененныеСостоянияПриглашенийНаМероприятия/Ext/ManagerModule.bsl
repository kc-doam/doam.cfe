﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ДобавитьЗапись(Пользователь, Мероприятие) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НЗ = СоздатьНаборЗаписей();
	НЗ.Отбор.Мероприятие.Установить(Мероприятие);
	НЗ.Отбор.Пользователь.Установить(Пользователь);
	
	МЗ = НЗ.Добавить();
	МЗ.Пользователь = Пользователь;
	МЗ.Мероприятие = Мероприятие;
	МЗ.ОтметкаВремени = ОтметкиВремени.Текущая();
	НЗ.Записать();
	
КонецПроцедуры

#КонецЕсли
