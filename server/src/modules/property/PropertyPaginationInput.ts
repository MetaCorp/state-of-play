import { Field, InputType } from "type-graphql";

@InputType()
export class PropertyPaginationInput {
  @Field({ nullable: true })
  afterCursor: string;

  @Field({ nullable: true })
  beforeCursor: string;
  
  @Field({ nullable: true })
  limit: number;
}
