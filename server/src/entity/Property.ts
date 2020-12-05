import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, ManyToOne, OneToMany } from "typeorm";
import { ObjectType, Field, ID } from "type-graphql";

import { User } from "./User";
import { StateOfPlay } from "./StateOfPlay";

@ObjectType()
@Entity()
export class Property extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: number;

  @Field()
  @Column()
  address: string;
  
  @Field()
  @Column()
  postalCode: string;

  @Field()
  @Column()
  city: string;

  // @Field()
  // @Column()
  // type: string;

  // @Field()
  // @Column()
  // reference: string;

  // @Field()
  // @Column()
  // lot: string;

  // @Field()
  // @Column()
  // floor: number;

  // @Field()
  // @Column()
  // roomCount: number;

  // @Field()
  // @Column()
  // area: number;

  // // @Field()
  // // @Column()
  // // annexes: [string];

  // @Field()
  // @Column()
  // heatingType: string;

  // @Field()
  // @Column()
  // hotWater: string;

  @Field(() => User)
  @ManyToOne(() => User, user => user.properties)
  user: User;
  
  @Field(() => [StateOfPlay])
  @OneToMany(() => StateOfPlay, stateOfPlay => stateOfPlay.property)
  stateOfPlays: StateOfPlay[];
}
