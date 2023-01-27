import { IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';
import { PaginationOptions } from './pagination.options.dto';

export class CreateRestaurantDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  address: string;
}

export enum FilterOperator {
  $eq,
  $gt,
  $gte,
  $lt,
  $lte,
  $ne,
}

export class FilterRelation<T> {
  operator: FilterOperator;
  value: T;
}

export class FilterRelations<T> {
  relations: FilterRelation<T>[];
}

export class FilterOptions {
  [k: string]: any;

  @IsOptional()
  name: FilterRelations<string>;

  @IsOptional()
  address: FilterRelations<string>;

  @IsOptional()
  ownerId: FilterRelations<string>;

  @IsOptional()
  averageRating: FilterRelations<number>;
}

export enum SortCriteria {
  Ascending = 'Ascending',
  Descending = 'Descending',
}

export class SortOptions {
  @IsOptional()
  @IsEnum(SortCriteria)
  name: SortCriteria;

  @IsOptional()
  @IsEnum(SortCriteria)
  address: SortCriteria;

  @IsOptional()
  @IsEnum(SortCriteria)
  averageRating: SortCriteria;
}

export class GetRestaurantsDto {
  @IsOptional()
  filterOptions: FilterOptions;

  @IsOptional()
  sortOptions: SortOptions;

  @IsOptional()
  paginationOptions: PaginationOptions;
}

export class DeleteRestaurantDto {
  @IsString()
  id: string;
}

export class UpdateRestaurantDto {
  @IsString()
  @IsNotEmpty()
  id: string;

  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  address: string;
}

export class GetRestaurantDto {
  @IsString()
  @IsNotEmpty()
  id: string;
}
