import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany } from "typeorm";
import { ObjectType, Field, ID } from "type-graphql";

import { StateOfPlay } from "./StateOfPlay"

@ObjectType()
@Entity()
export class Representative extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: number;

  @Field()
  @Column()
  firstName: string;

  @Field()
  @Column()
  lastName: string;

  @Field(() => StateOfPlay)
  @OneToMany(() => StateOfPlay, stateOfPlay => stateOfPlay.representative)
  stateOfPlays: StateOfPlay[];
}
