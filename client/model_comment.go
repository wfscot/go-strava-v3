/*
 * Strava API v3
 *
 * The [Swagger Playground](https://developers.strava.com/playground) is the easiest way to familiarize yourself with the Strava API by submitting HTTP requests and observing the responses before you write any client code. It will show what a response will look like with different endpoints depending on the authorization scope you receive from your athletes. To use the Playground, go to https://www.strava.com/settings/api and change your “Authorization Callback Domain” to developers.strava.com. Please note, we only support Swagger 2.0. There is a known issue where you can only select one scope at a time. For more information, please check the section “client code” at https://developers.strava.com/docs.
 *
 * API version: 3.0.0
 * Generated by: Swagger Codegen (https://github.com/swagger-api/swagger-codegen.git)
 */

package client

import (
	"time"
)

type Comment struct {
	// The unique identifier of this comment
	Id int64 `json:"id,omitempty"`
	// The identifier of the activity this comment is related to
	ActivityId int64 `json:"activity_id,omitempty"`
	// The content of the comment
	Text string `json:"text,omitempty"`
	Athlete *SummaryAthlete `json:"athlete,omitempty"`
	// The time at which this comment was created.
	CreatedAt time.Time `json:"created_at,omitempty"`
}
