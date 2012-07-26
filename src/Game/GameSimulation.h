
#pragma once
#include <Talon/Simulation.h>

class GameSimulation : public Talon::Simulation
{
public:
	GameSimulation(void);
	virtual ~GameSimulation(void);

protected:
	void OnInitialized();
	void OnBeginFrame();
	void OnEndFrame();
	void OnShutdown();
};