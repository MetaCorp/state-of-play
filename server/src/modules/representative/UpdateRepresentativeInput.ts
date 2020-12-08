import { Field, InputType } from "type-graphql";
import { CreateRepresentativeInput } from "./CreateRepresentativeInput";

@InputType()
export class UpdateRepresentativeInput {  
    @Field()
    representativeId: string;

    @Field()
    representative: CreateRepresentativeInput
}
