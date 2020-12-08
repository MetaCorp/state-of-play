import { Field, InputType } from "type-graphql";
import { CreatePropertyInput } from "./CreatePropertyInput";

@InputType()
export class UpdatePropertyInput {  
    @Field()
    propertyId: string;

    @Field()
    property: CreatePropertyInput
}
