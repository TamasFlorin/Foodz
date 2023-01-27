import { IsNumber, IsOptional } from 'class-validator';

export class PaginationOptions {
  @IsOptional()
  @IsNumber()
  pageNumber = 0;

  @IsOptional()
  @IsNumber()
  itemsPerPage = 10;
}
