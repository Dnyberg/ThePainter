using UnityEngine;
using System.Linq;
using System.Collections.Generic;
using UnityEngine.SceneManagement;

public class PuzzleManager : Singleton<PuzzleManager>
{
    private List<PuzzleSolver> solvers = new List<PuzzleSolver>();
    private List<PuzzleReceiver> receivers = new List<PuzzleReceiver>();

    private void Awake()
    {
        // Process new scenes as they are loaded
        SceneManager.sceneLoaded += (scene, mode) =>
        {
            Process(scene);
        };
    }

    public void Process(Scene scene)
    {
        // Get all the root game objects in the scene
        var _root = scene.GetRootGameObjects();

        // Get all matching components from all children of the root nodes
        var _solvers = _root.SelectMany(go => go.GetComponentsInChildren<PuzzleSolver>());
        var _receivers = _root.SelectMany(go => go.GetComponentsInChildren<PuzzleReceiver>());

        // Connect local solvers to local receivers
        ConnectPuzzles(_solvers, _receivers);

        // Connect local solvers to global receivers
        ConnectPuzzles(_solvers, receivers);

        // Connect global solvers to local receivers
        ConnectPuzzles(solvers, _receivers);

        // Add the local solvers/receivers to the global list after we've connected them
        solvers.AddRange(_solvers);
        receivers.AddRange(_receivers);
    }

    /// <summary>
    /// Connects solvers and receivers with matching identiifers.
    /// </summary>
    public void ConnectPuzzles(IEnumerable<PuzzleSolver> solvers, IEnumerable<PuzzleReceiver> receivers)
    {
        // Nothing to attach
        if (solvers.Count() <= 0 || receivers.Count() <= 0)
            return;

        foreach (var solver in solvers)
        {
            // Ignore undefined puzzles
            if (string.IsNullOrWhiteSpace(solver.Identifier))
                continue;

            // In case the OnSolved event was improperly set up 
            Debug.Assert(solver.OnSolved != null, $"OnSolved event in solver for {solver.Identifier} was not set up correctly.");

            // Get receivers that match the solver identifier
            var matches = receivers.Where(r => r.Identifier.ToLower() == solver.Identifier.ToLower());

            foreach (var receiver in matches)
            {
                solver.OnSolved?.AddListener(receiver.Trigger);

                Debug.Log($"Connected puzzle: {solver.Identifier}");
            }
        }
    }
}