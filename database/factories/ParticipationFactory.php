<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\Participation;
use App\Models\Student;
use App\Models\Event;

class ParticipationFactory extends Factory
{
    protected $model = Participation::class;

    public function definition()
    {
        $student = Student::inRandomOrder()->first() ?? Student::factory()->create();
        $event = Event::inRandomOrder()->first() ?? Event::factory()->create();

        // Generate time_in within the last 30 days, with some variation
        $timeIn = $this->faker->dateTimeBetween('-30 days', 'now');

        // time_out is optional, and if present, after time_in
        $timeOut = $this->faker->boolean(70) ? // 70% chance of having time_out
            $this->faker->dateTimeBetween($timeIn, $timeIn->format('Y-m-d H:i:s') . ' +4 hours') :
            null;

        return [
            'student_id' => $student->id,
            'event_id' => $event->id,
            'time_in' => $timeIn,
            'time_out' => $timeOut,
        ];
    }
}
