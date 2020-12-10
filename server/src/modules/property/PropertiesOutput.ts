import { Property } from "../../entity/Property";
import { Field, ObjectType } from "type-graphql";

@ObjectType()
class CursorOutput {
    @Field({ nullable: true })
    afterCursor: string

    @Field({ nullable: true })
    beforeCursor: string
}

@ObjectType()
export class PropertiesOutput {
  @Field(() => CursorOutput)
  cursor: CursorOutput;

  @Field(() => [Property])
  data: [Property];
}