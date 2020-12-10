import { Field, InputType } from "type-graphql";
import { CreateTenantInput } from "./CreateTenantInput";

@InputType()
export class UpdateTenantInput {  
    @Field()
    tenantId: string;

    @Field()
    tenant: CreateTenantInput
}
