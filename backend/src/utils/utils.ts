import { FilterOptions, FilterRelation } from '@dtos/restaurant.dto';

export function idsEqual(first: any, second: any): boolean {
  return String(first) == String(second);
}

export function filterOptionsToMongoQuery(filterOptions: FilterOptions): any {
  const result: any = {};
  if (filterOptions === undefined || filterOptions === null) {
    return result;
  }
  Object.keys(filterOptions).forEach((k, _) => {
    filterOptions[k].relations.forEach((rel: FilterRelation<any>, _: number) => {
      if (result[k] === undefined) {
        result[k] = {};
      }
      result[k][rel.operator] = rel.value;
    });
  });
  return result;
}
